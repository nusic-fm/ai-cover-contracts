// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AICoverToken.sol";

contract AICoverTokenController is Ownable {

    mapping(string => uint256) public totalEarnedByVoiceId;
    mapping(string => uint256) public currentHoldingsByVoiceId;
    address aiCoverTokenAddress;

    address public minterAddress;
    address public manager;

    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    modifier onlyOwnerOrManagerOrMinter() {
        require((owner() == msg.sender) || (manager == msg.sender) || (minterAddress == msg.sender), "Caller needs to be Owner or Manager or Minter");
        _;
    }

    event TokenMintedForVoice(string voiceId, uint256 amount, uint256 timestamp);
    event TokenWithdrawForVoice(address useAddress, string voiceId, uint256 amount, uint256 timestamp);

    constructor(address tokenAddress_) {
        aiCoverTokenAddress = tokenAddress_;
    }

    function mint(string memory voiceId, uint256 amount) public onlyOwnerOrManagerOrMinter {
        totalEarnedByVoiceId[voiceId]+=amount;
        currentHoldingsByVoiceId[voiceId]+=amount;
        AICoverToken aiCoverToken = AICoverToken(aiCoverTokenAddress);
        aiCoverToken.mint(address(this), amount);
        emit TokenMintedForVoice(voiceId, amount, block.timestamp);
    }

    function withdraw(string memory voiceId) public {
        require(currentHoldingsByVoiceId[voiceId]>0, "No Token to withdraw");
        AICoverToken aiCoverToken = AICoverToken(aiCoverTokenAddress);
        uint256 currentHoldings = currentHoldingsByVoiceId[voiceId];
        aiCoverToken.transfer(msg.sender, currentHoldings);
        currentHoldingsByVoiceId[voiceId] = 0;
        emit TokenWithdrawForVoice(msg.sender, voiceId, currentHoldings, block.timestamp);
    }
}
