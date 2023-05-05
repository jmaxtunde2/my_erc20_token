// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.17;

// define all function contract can implement
interface IERC20 {
    function transfer(address to, uint256 amount) external view returns (bool);
    function balanceOf(address account) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet{
    address payable owner;
    IERC20 public token;
    uint256 public withdrawalAmount = 50 * (10**18);
    uint256 public lockTime = 1 minutes;

    //define next time access
    mapping(address => uint256) nextAccessTime;

    // event
    event Deposit(address indexed from, uint256 indexed amount);
    event withdrawl(address indexed from, uint256 indexed amount);

    constructor(address tokenAdress) payable {
        token = IERC20(tokenAdress);
        owner = payable(msg.sender);
    }

    //Request Token
    //This function allows user or developer to request Cori Token
    function requestToken() public {
        require(msg.sender != address(0), "Request must not originate from 0 account");
        require(token.balanceOf(address(this)) >= withdrawalAmount, "Insufficient balance in the faucet for withdrawal request.");
        require(block.timestamp > nextAccessTime[msg.sender], "Insufficient time elapsed since last widthdrawal - try again later");
        
        // set next access time
        nextAccessTime[msg.sender] = block.timestamp + lockTime;
        // transfer token 
        token.transfer(msg.sender, withdrawalAmount);
    }

    // deposit token
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }

    // get balance
    function getBalance() external view returns (uint256){
       return token.balanceOf(address(this));
    }

    // set withdrawal
    function setWithdrawal(uint amount) public onlyOwner {
        withdrawalAmount = amount * (10**18);
    }

    // set lock time
    function setLocktime(uint256 amount) public onlyOwner{
        lockTime = amount * 1 minutes;
    }

    //
    function withdrawal() external onlyOwner{
        emit withdrawl(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner(){
        require(msg.sender == owner, " Only the contract owner can call this function");
        _;
    }

    
}
