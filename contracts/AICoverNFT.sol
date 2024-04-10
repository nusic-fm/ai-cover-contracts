// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";


contract AICoverNFT is ERC721, Pausable, Ownable, ReentrancyGuard{
    using Strings for uint256;

    string public songId;
    string public userId;
    string public songName;
    address public manager;

    struct AICoverInfo {
        address userAddress;
        uint256 tokenId;
        string voiceId;
        string voiceName;
        string voiceModelCreatorId;
        string coverCreatorId;
    }

    uint256 public tokenMinted;
    mapping(uint256 => AICoverInfo) public aiCoverInfo;

    string public defaultURI = "";

    mapping(uint256 => string) private tokenURIs;
    mapping(address => uint256) public splitInfo;

    event AICoverMinted(address indexed to, uint256 tokenId, string voiceId, string voiceName, string voiceModelCreatorId, string coverCreatorId);

    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor(string memory _name, string memory _symbol, string memory _songId, string memory _userId, string memory _songName) ERC721(_name, _symbol)  {
        manager = 0x07C920eA4A1aa50c8bE40c910d7c4981D135272B;
        songId = _songId;
        userId = _userId;
        songName = _songName;
    }

    function updateUserId(string memory _userId) public onlyOwnerOrManager {
        userId = _userId;
    }

    function updateSongName(string memory _songName) public onlyOwnerOrManager {
        songName = _songName;
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

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exists");
        string memory _tokenURI = tokenURIs[tokenId];
        return bytes(_tokenURI).length > 0 ? _tokenURI : defaultURI;
    }

    function mintAICover(string memory _voiceId, string memory _voiceName, string memory _voiceModelCreatorId, string memory _coverCreatorId, string memory _tokenURI) public whenNotPaused nonReentrant{
        AICoverInfo storage info = aiCoverInfo[tokenMinted];
        //require(model.userAddress == address(0), "UserModel already exists");
        info.userAddress = msg.sender;
        info.tokenId = tokenMinted;
        info.voiceId = _voiceId;
        info.voiceName = _voiceName;
        info.voiceModelCreatorId = _voiceModelCreatorId;
        info.coverCreatorId = _coverCreatorId;

        _safeMint(msg.sender, tokenMinted);
        tokenURIs[tokenMinted] = _tokenURI;
        emit AICoverMinted(msg.sender, tokenMinted++, _voiceId, _voiceName, _voiceModelCreatorId, _coverCreatorId);
    }
    
    function updateSplit(address[] memory addressList, uint256[] memory splitList) public nonReentrant{
        require(addressList.length == splitList.length, "Length mismatch");
        uint256 splitTotal = 0;
        for (uint256 i = 0; i < addressList.length; i++) {
            require(addressList[i] != address(0),"NULL Address Provided");
            splitTotal += splitList[i];
        }
        require(splitTotal == 10000,"Splits are not equal to 100%");
        for (uint256 i = 0; i < addressList.length; i++) {
            splitInfo[addressList[i]] = splitList[i];
        }
    }

    function pause() public onlyOwnerOrManager nonReentrant {
        _pause();
    }

    function unpause() public onlyOwnerOrManager nonReentrant {
        _unpause();
    }

}