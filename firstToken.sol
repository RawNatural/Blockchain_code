// contracts/cryptocurrency.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/ERC20.sol";

contract firstToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("FirstToken", "FST") {
        _mint(msg.sender, initialSupply);
    }
}