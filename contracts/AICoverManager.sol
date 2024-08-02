// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";


contract AICoverManager is Ownable {
    using Strings for uint256;

    uint256 constant public TOTAL_SHARE = 10000; // Equal to 100%
    string public _url;
    string public _title;
    string public _coverId;
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
    // Index will start from 1 so that we can keep the track of length
    uint256 public stakeholderIndex;
    mapping(uint256 => Stakeholder) public stakeholders;
    
    address[] public aiVoiceNFTList;

    event StackholderAdded(uint256 stakeholderIndex, address stakeholderAddress, uint256 _type, uint256 share);
    
    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor(string memory url_, string memory title_, string memory coverId_) {
        _url = url_;
        _title = title_;
        _coverId = coverId_;
        manager = msg.sender;
    }

    function setManager(address _manager) public onlyOwnerOrManager {
        manager = _manager;
    }

    function addStackholders(Stakeholder[] memory stackeholders_) public {
        require(stackeholders_.length !=0, "Empty List");
        uint256 totalShare = 0;
        for (uint256 i = 0; i < stackeholders_.length; i++) {
            totalShare+=stackeholders_[i].share;
            require(totalShare <= TOTAL_SHARE, "Share cannot be more than 100%");
            stakeholders[++stakeholderIndex] = stackeholders_[i];
            emit StackholderAdded(stakeholderIndex,stackeholders_[i].userAddress, uint256(stackeholders_[i]._type), stackeholders_[i].share);
        }
    }

    function addAIVoiceNFT(address _aiVoiceNFTAddress) public {
        aiVoiceNFTList.push(_aiVoiceNFTAddress);
    }

}