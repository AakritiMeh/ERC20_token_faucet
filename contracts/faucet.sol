//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    function balanceOf(address account) external view returns (uint256);
}

contract Faucet {
    address payable owner;
    IERC20 public token;

    uint256 public withdrawlAmount = 50 * (10 ** 18);
    mapping(address => uint256) nextAccessTime;
    uint256 public lockTime = 1 minutes;

    event Withdrawl(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestTokens() public {
        require(msg.sender != address(0), "invalid address");

        require(
            token.balanceOf(address(this)) >= withdrawlAmount,
            "insufficient balance"
        );

        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "insufficient time elapse since last withdraw"
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;
        token.transfer(msg.sender, withdrawlAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawlAmount(uint256 amount) public onlyOwner {
        withdrawlAmount = amount * (10 ** 18);
    }

    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 1 minutes;
    }

    function withdrawl() external onlyOwner {
        emit Withdrawl(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only contract owner can call this function"
        );
        _;
    }
}
