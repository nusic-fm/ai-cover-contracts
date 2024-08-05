// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./AICoverToken.sol";

contract AICoverTokenController is AccessControl {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(string => uint256) public totalEarnedByVoiceId;
    mapping(string => uint256) public currentHoldingsByVoiceId;
    address aiCoverTokenAddress;

    event TokenMintedForVoice(string voiceId, uint256 amount, uint256 timestamp);
    event TokenWithdrawForVoice(address useAddress, string voiceId, uint256 amount, uint256 timestamp);

    constructor(address tokenAddress_, address defaultAdmin, address pauser, address minter) {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
        aiCoverTokenAddress = tokenAddress_;
    }

    function mint(string memory voiceId, uint256 amount) public onlyRole(MINTER_ROLE){
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
        aiCoverToken.transferFrom(address(this), msg.sender, currentHoldings);
        currentHoldingsByVoiceId[voiceId] = 0;
        emit TokenWithdrawForVoice(msg.sender, voiceId, currentHoldings, block.timestamp);
    }
}
