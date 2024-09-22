// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AICoverToken is ERC20, Ownable {

    address public minterContractAddress;
    address public manager;

    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    modifier onlyOwnerOrManagerOrMinter() {
        require((owner() == msg.sender) || (manager == msg.sender) || (minterContractAddress == msg.sender), "Caller needs to be Owner or Manager or Minter");
        _;
    }
    constructor() ERC20("AI Cover Token", "DD1") {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwnerOrManagerOrMinter{
        _mint(to, amount);
    }

    function setManager(address _manager) public onlyOwnerOrManager {
        manager = _manager;
    }

    function setMinter(address _minter) public onlyOwnerOrManager {
        minterContractAddress = _minter;
    }

}
