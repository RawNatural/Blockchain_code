// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/IERC20.sol";

contract VerifiedTransfer {
    using SafeMath for uint256;

    // Mapping to store transfer data
    mapping (bytes32 => Transfer) public transfers;

    // Struct to store transfer data
    struct Transfer {
        address sender;
        uint256 amount;
        address recipient;
        bool verified;
    }

    // Address of the token contract
    IERC20 public token;

    // Address of the owner of the contract
    address public owner;

    // Array of verifier addresses
    address[] public verifiers;

    // Constructor to set the owner and token contract
    constructor(address _owner, address _token) public {
        owner = _owner;
        token = IERC20(_token);
    }

    // Function to add verifiers
    function addVerifier(address _verifier) public {
        // Only the owner can add verifiers
        require(msg.sender == owner, "Only the owner can add verifiers");

        // Check that the verifier is not already in the array
        require(indexOf(_verifier) == -1, "Verifier is already in the array");

        // Add the verifier to the array
        verifiers.push(_verifier);
    }



    // Function to initiate a transfer
    function initiateTransfer(bytes32 transferId, address recipient, uint256 amount) public {
        // Check that the sender is not the recipient
        require(msg.sender != recipient, "Sender and recipient cannot be the same");

        // Check that the transfer ID is not already in use
        require(transfers[transferId].amount == 0, "Transfer ID is already in use");

        // Check that the amount is greater than 0
        require(amount > 0, "Amount must be greater than 0");

        // Store the transfer data in the mapping
        transfers[transferId] = Transfer(msg.sender, amount, recipient, false);

    }

    // Function to verify a transfer
    function verifyTransfer(bytes32 transferId) public {
        // Get the transfer data from the mapping
        Transfer storage transfer = transfers[transferId];

        // Check that the caller is a verifier
        require(isVerifier(), "Caller is not a verifier");

        // Mark the transfer as verified
        transfer.verified = true;

        // Approve ERC20 transfer
        approveTransfer(transferId);
    }

    // Function to execute a transfer
    function executeTransfer(bytes32 transferId) public {
        // Get the transfer data
        Transfer memory transfer = transfers[transferId];

        // Check that the transfer has been verified
        require(transfer.verified, "Transfer has not been verified");

        // Transfer the tokens to the recipient
        token.transfer(transfer.recipient, transfer.amount);
    }

    //Function to approve ERC20 transfer
    function approveTransfer(bytes32 transferId) public {
        // Get the transfer data
        Transfer memory transfer = transfers[transferId];

        // Approve ERC20 send amount from msg.sender
        token.approve(transfer.sender, transfer.amount);
    }

    // Helper function to get the index of an address in the verifiers array
    function indexOf(address _address) private view returns (int256) {
        for (uint256 i = 0; i < verifiers.length; i++) {
            if (verifiers[i] == _address) {
                return int256(i);
            }
        }
        return -1;
    }

    // Function to check if the caller is a verifier
    function isVerifier() private view returns (bool) {
        for (uint256 i = 0; i < verifiers.length; i++) {
            if (verifiers[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }
}
