// contracts/NewToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NewToken {

    function mintNewToken(string memory name_, string memory symbol_, uint256 initialSupply){
        const theNewToken = new ERC20(name_, symbol_);
        theNewToken._mint(msg.sender, initialSupply);
        return theNewToken;
    }
}

