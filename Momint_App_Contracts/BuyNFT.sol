// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "./CustomCoin.sol";
import "../CustomSafeMath.sol";
import "./Mint_With_Sell.sol";

contract BuyNFT is CustomCoin{
    using CustomSafeMath for uint256;

    address public conOwner;

    constructor() public CustomCoin(1000) {
        conOwner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == conOwner, "Only the owner can call this function");
        _;
    }


    //CustomCoin coin; // Replace with the actual address of the ERC20 token contract

    Mint_With_Sell mintNFT;

    function buy(uint256 _tokenId) public payable {
        uint256 price = mintNFT.getTokenPrice(_tokenId);
        bool onSale = mintNFT.getIfOnSale(_tokenId);
        require(onSale, "Token Not For Sale");
        require(price > 0, "Invalid token price");

        // Calculate the amount to be burned (30% of the payment)
        uint256 burnAmount = price.mul(30).div(100);

        // Calculate the amount to be sent to the seller (70% of the payment)
        uint256 sellerAmount = price.sub(burnAmount);

        approve(address(this), price);
        // Step 1: Transfer ERC20 tokens from the buyer to the contract
        require(allowance(msg.sender, address(this)) >= price, "Insufficient allowance");
        //require(transferFrom(msg.sender, address(this), price), "Token transfer failed");

        // Step 2: Transfer the ownership of the NFT from the seller to the buyer
        address seller = mintNFT.ownerOf(_tokenId);
        require(seller != address(0), "Invalid seller address");
        require(seller != msg.sender, "You cannot buy your own NFT");
        mintNFT.safeTransferFrom(seller, msg.sender, _tokenId);

        // Burn the tokens from the buyer's balance
        _burn(msg.sender, burnAmount);

        // Step 3: Transfer the ERC20 tokens from the contract to the seller
        require(transfer(seller, sellerAmount), "Token transfer to the seller failed");

        // Clear the sale offer after the successful purchase
        mintNFT.itemBought(_tokenId);
    }


/*
    function buy(uint256 _tokenId) public payable {
        uint256 price = mintNFT.getTokenPrice(_tokenId);
        bool onSale = mintNFT.getIfOnSale(_tokenId);
        require(onSale, "Token Not For Sale");
        require(price > 0, "Invalid token price");

        approve(address(this), price);
        // Step 1: Transfer ERC20 tokens from the buyer to the contract
        require(allowance(msg.sender, address(this)) >= price, "Insufficient allowance");
        //require(transferFrom(msg.sender, address(this), price), "Token transfer failed");

        // Step 2: Transfer the ownership of the NFT from the seller to the buyer
        address seller = mintNFT.ownerOf(_tokenId);
        require(seller != address(0), "Invalid seller address");
        require(seller != msg.sender, "You cannot buy your own NFT");
        mintNFT.safeTransferFrom(seller, msg.sender, _tokenId);

        // Step 3: Transfer the ERC20 tokens from the contract to the seller
        require(transfer(seller, price), "Token transfer to the seller failed");

        // Clear the sale offer after the successful purchase
        mintNFT.itemBought(_tokenId);
    }*/


    function setMintAddress(address _mintAddy) public onlyOwner {
        mintNFT = Mint_With_Sell(_mintAddy);
    }
/*
    function setCoinAddress(address _coinAddy)  public onlyOwner {
        coin = CustomCoin(_coinAddy);
    }*/

}