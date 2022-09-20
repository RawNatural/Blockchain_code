// SPDX-License-Identifier: unlicensed

pragma solidity 0.5.0;

import "./ERC721Full.sol";

contract MintNFT is ERC721Full {

    constructor() ERC721Full("New NFT", "NFT") public {
    }

    function mint(address _to, string memory _tokenURI) public returns(bool) {
       uint _tokenId = totalSupply().add(1);
       _mint(_to, _tokenId);
       _setTokenURI(_tokenId, _tokenURI);
       return true;
    }
}
