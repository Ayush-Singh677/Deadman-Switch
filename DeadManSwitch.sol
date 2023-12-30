pragma solidity ^0.8.0;

contract AutoSendContract {
    address public owner=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public presetAddress=0xc79B3091023Aa511e4574861BECeB3A0B7462537;
    uint256 public lastAliveBlock;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier stillAlive() {
        require(block.number - lastAliveBlock < 10, "Owner not alive");
        _;
    }

    constructor(address _presetAddress) {
        owner = msg.sender;
        presetAddress = _presetAddress;
        lastAliveBlock = block.number;
    }

    function still_alive() external onlyOwner {
        lastAliveBlock = block.number;
    }

    function sendBalanceToPresetAddress() external stillAlive onlyOwner {
        uint256 balanceToSend = address(this).balance;
        require(balanceToSend > 0, "No balance to send");
        
        // Send the balance to the preset address
        (bool success, ) = presetAddress.call{value: balanceToSend}("");
        require(success, "Transfer failed");
    }

    // Fallback function to receive ether
    receive() external payable {}

    // Function to get the contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
