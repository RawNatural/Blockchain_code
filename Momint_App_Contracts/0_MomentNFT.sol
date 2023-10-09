// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "./ERC721Full.sol";

contract MomentNFT is ERC721Full {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() ERC721Full("Moment NFT", "MNT") public {
        owner = msg.sender;
    }

    function mint(address _to, string memory _tokenURI) public returns(bool) {
       uint _tokenId = totalSupply().add(1);
       _mint(_to, _tokenId);
       _setTokenURI(_tokenId, _tokenURI);
       return true;
    }

}