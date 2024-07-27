// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./AICoverManager.sol";


contract AICoverManagerFactory is Ownable {
    using Strings for uint256;

    address public manager;
    event AICoverManagerDeployed(string url_, string title_, string coverId_, address contractAddress);
    
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

    function createAICoverManager(string memory url_, string memory title_, string memory coverId_) public onlyOwnerOrManager {
        AICoverManager aiCoverManager = new AICoverManager(url_, title_, coverId_);
        aiCoverManager.transferOwnership(msg.sender);
        emit AICoverManagerDeployed(url_, title_, coverId_, address(aiCoverManager));
    }

}