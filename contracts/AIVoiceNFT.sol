// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";


contract AIVoiceNFT is ERC721, Pausable, Ownable, ReentrancyGuard{
    using Strings for uint256;

    string public defaultURI = "";
    string private baseURI = "";

    address public manager;
    uint256 public tokenMinted;
    uint256 public constant MAX_SUPPLY = 1; // Do we need this?
    
    string public url;
    string public coverId;
    string public voiceId;
 
    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor(string memory _name, string memory _symbol, string memory _url, string memory _coverId, string memory _voiceId) ERC721(_name, _symbol)  {
        url = _url;
        coverId = _coverId;
        voiceId = _voiceId;
        manager = msg.sender;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

    function _baseURI() internal view override returns (string memory) {
        return defaultURI;
    }

    function setDefaultRI(string calldata _defaultURI) public onlyOwnerOrManager {
		defaultURI = _defaultURI;
	}

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token does not exists");
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : defaultURI;
    }

    function pause() public onlyOwnerOrManager nonReentrant {
        _pause();
    }

    function unpause() public onlyOwnerOrManager nonReentrant {
        _unpause();
    }

}