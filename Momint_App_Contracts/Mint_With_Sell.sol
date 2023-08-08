// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;


import "../MintNFT.sol";

contract Mint_With_Sell is MintNFT {

    address buyContract;

        //Mapping which pairs tokenId to a price
    mapping (uint256 => uint256) internal tokenPrice;

    //Mapping which shows which tokenIds are for sale. True if yes for sale
    mapping (uint256 => bool) internal isForSale;


    function sell(uint256 _tokenId, uint256 _sellPrice) public { //maybe change to private
        address ownerOfToken = ownerOf(_tokenId);
 
        require(ownerOfToken == msg.sender, "You are not the owner of this token");
        tokenPrice[_tokenId] = _sellPrice;
        approve(buyContract, _tokenId);
        isForSale[_tokenId] = true;
    }



    function getIfOnSale(uint256 _tokenId) public view returns(bool){
        bool yes = isForSale[_tokenId];
        return yes;
    }

    function getTokenPrice(uint256 _tokenId) public view returns(uint256){
        uint256 itemPrice = tokenPrice[_tokenId];
        return itemPrice;
    }

    function setBuyContract(address _buyAddy) onlyOwner public {
        buyContract = _buyAddy;
    }
}