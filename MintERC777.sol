pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract NewERC777 is ERC777 {
    constructor(
        uint256 initialSupply,
        address[] memory defaultOperators,
        string memory name,
        string memory symbol
    )
        ERC777(name, symbol, defaultOperators)
        public
    {
        _mint(msg.sender, msg.sender, initialSupply, "", "");
    }
}

contract MintERC777 {
	NewERC777 newERC777;
	function createERC777() external {
		address[] memory emtArray;
		newERC777 = new NewERC777(1000000, emtArray, "Naecoin", "NAE");

	}
}