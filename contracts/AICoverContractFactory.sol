// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./AICoverNFT.sol";


contract AICoverContractFactory is Ownable {
    using Strings for uint256;

    address public manager;
    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    event AICoverContractDeployed(string _name, string _symbol, string songId, string userId, string _songName, address contractAddress, address deployer);

    constructor() {
        manager = 0x07C920eA4A1aa50c8bE40c910d7c4981D135272B;
    }

    function deployAICoverContract(string memory _name, string memory _symbol, string memory _songId, string memory _userId, string memory _songName) public {
        AICoverNFT aiCoverNFT = new AICoverNFT(_name, _symbol, _songId, _userId, _songName);
        emit AICoverContractDeployed(_name, _symbol, _songId, _userId, _songName, address(aiCoverNFT), msg.sender);
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

}