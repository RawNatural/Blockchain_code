// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;


import "../1_MomentNFT.sol";

contract Mint_With_Sell is MomentNFT {

    address buyContract;

        //Mapping which pairs tokenId to a price
    mapping (uint256 => uint256) internal tokenPrice;

    //Mapping which shows which tokenIds are for sale. True if yes for sale
    mapping (uint256 => bool) internal isForSale;


    function sell(uint256 _tokenId, uint256 _sellPrice) public { //maybe change to private
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner of this token");
        tokenPrice[_tokenId] = _sellPrice;
        approve(buyContract, _tokenId);
        isForSale[_tokenId] = true;
    }

    //Modifier for only callable by my buy contract
    modifier onlyBuyContract() {
        require(msg.sender == buyContract, "Only callable by Buy Contract");
        _;
    }

    //Function to unlist an item for sale. Called only from buy contract when it buys. 
    function itemBought(uint256 _tokenId) public onlyBuyContract {
        isForSale[_tokenId] = false;
        tokenPrice[_tokenId] = 0; // using zero to represent unavailable for sale. It should be fine. Buy contract requires price > 0.
    }

    //Function to unlist an item for sale. Called only directly from owner of token.
    function unListItem(uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "You are not the owner of this token");
        require(isForSale[_tokenId], "Token is already not for sale");
        isForSale[_tokenId] = false;
        tokenPrice[_tokenId] = 0; // using zero to represent unavailable for sale. It should be fine. Buy contract requires price > 0.
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
