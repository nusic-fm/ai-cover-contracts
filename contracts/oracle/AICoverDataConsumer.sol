// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;
//import "@opendatafabric/contracts/src/Odf.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import { OdfRequest, OdfResponse, IOdfClient, CborReader } from "@opendatafabric/contracts/src/Odf.sol";

// This sample contract makes an ODF oracle query to calculate
// a Canadian province with the most recorded COVID-19 cases
contract AICoverDataConsumer {
    using OdfRequest for OdfRequest.Req;
    using OdfResponse for OdfResponse.Res;
    using CborReader for CborReader.CBOR;

    IOdfClient private oracle;
    string public coverName;
    int public playtime;
        
    //event EventResultStarted(string _name, string _symbol, string songId, string userId, string _songName, address contractAddress, address deployer);
    event EventResultStages(string _stage, uint256 _number);
    event EventResultOracle(address _oracleAddress);
    event EventResultNumRecords(uint256 _numRecords);

    // Initialize contract with the oracle address
    constructor(address oracleAddr) {
        oracle = IOdfClient(oracleAddr);
    }

    function initiateQuery() public {
        OdfRequest.Req memory req = OdfRequest.init();

        // Specify ID of the dataset(s) we will be querying.
        // Repeat this call for multiple inputs.
        req.dataset(
            "cover_playtimes",
            "did:odf:fed012571ce8706eb3aafb7125e3eaf9a236c21ced9e6043b49dff80566c64d83bee5"
        );

        // Specify an arbitrary complex SQL query.
        // Queries can include even JOINs
        req.sql(
            "select "
            "  voice_id, "
            "  sum(end_time - start_time) as playtime_total "
            "from cover_playtimes "
            "group by 1 "
            "order by 2 desc "
            "limit 10"
        );

        // Send request to the oracle and specify a callback
        oracle.sendRequest(req, this.onResult);
    }

    // This function will be called by the oracle when
    // request is fulfilled by some data provider
    function onResult(OdfResponse.Res memory result) external {
        emit EventResultStages("Started", 1);
        emit EventResultOracle(msg.sender);
        // Important: Make sure only the ODF oracle can supply you data
        require(msg.sender == address(oracle), "Can only be called by oracle");
        emit EventResultStages("After oracle check",2);
        // We expect only one row: [province, totalCases]
        emit EventResultNumRecords(result.numRecords());
        require(result.numRecords() == 1, "Expected one record");
        emit EventResultStages("After after num record check",3);
        
        CborReader.CBOR[] memory record = result.record(0);
        coverName = record[0].readString();
        emit EventResultStages(coverName,4);
        playtime = record[1].readInt();
        emit EventResultStages(Strings.toString(playtime),5);
        emit EventResultStages("End",6);
    }
}
