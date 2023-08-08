// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./CustomERC20.sol";

contract CustomCoin is CustomERC20 {
    constructor(uint256 initialSupply) public CustomERC20("TestMomintCustomToken", "MMC") {
        mint(msg.sender, initialSupply);
    }
}
