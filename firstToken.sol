// contracts/cryptocurrency.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract firstToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("FirstToken", "FST") {
        _mint(msg.sender, initialSupply);
    }
}

