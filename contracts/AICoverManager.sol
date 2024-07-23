// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";


contract AICoverManager is Ownable {
    using Strings for uint256;

    address public manager;

    enum StakeholderType{ 
        VOICE,
        VOICE_OWNER,
        RVC_MODEL_CREATOR,
        SONG,
        RECORDING_COMPANY,
        SONG_WRITER_COMPOSER 
    }

    struct Stakeholder {
        address userAddress;
        StakeholderType _type;
        uint256 share;
    }
    uint256 public stakeholderIndex;
    mapping(uint256 => Stakeholder) public _stakeholder;

    
    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

}