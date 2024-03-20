//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

//ERC20Capped in itself inherits ERC20, so we can remove it when we declare the contract and inherit the ERC20 stuff
contract gyaanToken is ERC20Capped {
    address payable public owner;

    uint256 public blockReward;

    constructor(
        uint256 cap,
        uint256 reward
    ) ERC20("gyaanToken", "GT") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 value
    ) internal {
        if (
            _from != address(0) &&
            _to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            _mintMinerReward();
        }

        _beforeTokenTransfer(_from, _to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    // function destroy() public onlyOwner {
    //     selfdestruct(owner);
    // }
    // this is depricated so not using

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call it");
        _;
    }
}
