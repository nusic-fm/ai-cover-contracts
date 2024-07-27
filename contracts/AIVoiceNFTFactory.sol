// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./AIVoiceNFT.sol";


contract AIVoiceNFTFactory is Ownable {
    using Strings for uint256;

    address public manager;
    event AIVoiceNFTDeployed(string _name, string _symbol, string _url, string _coverId, string _voiceId, address contractAddress);
    
    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function setManager(address _manager) public onlyOwnerOrManager {
        manager = _manager;
    }

    function createAICoverManager(string memory _name, string memory _symbol, string memory _url, string memory _coverId, string memory _voiceId) public onlyOwnerOrManager {
        AIVoiceNFT aiVoiceNFT = new AIVoiceNFT(_name,_symbol,_url, _coverId, _voiceId);
        aiVoiceNFT.transferOwnership(msg.sender);
        emit AIVoiceNFTDeployed(_name, _symbol, _url, _coverId, _voiceId, address(aiVoiceNFT));
    }

}