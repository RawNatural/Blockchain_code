// SPDX-License-Identifier: MIT

pragma solidity ^0.5.11;

contract BasicMaticTransfer {
    // Function to send Matic to a specified recipient
    function sendMatic(address payable recipient) external payable {
        require(msg.value > 0, "Must send Matic with a non-zero value");
        recipient.transfer(msg.value);
    }
}
