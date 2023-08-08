// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "./CustomCoin.sol";
import "./Mint_With_Sell.sol";

contract BuyNFT {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    CustomCoin coin; // Replace with the actual address of the ERC20 token contract

    Mint_With_Sell mintNFT;


    function buy(uint256 _tokenId) public payable {
        uint256 price = mintNFT.getTokenPrice(_tokenId);
        bool onSale = mintNFT.getIfOnSale(_tokenId);
        require(onSale, "Token Not For Sale");
        require(price > 0, "Invalid token price");

        coin.approve(address(this), price);
        // Step 1: Transfer ERC20 tokens from the buyer to the contract
        require(coin.allowance(msg.sender, address(this)) >= price, "Insufficient allowance");
        require(coin.transferFrom(msg.sender, address(this), price), "Token transfer failed");

        // Step 2: Transfer the ownership of the NFT from the seller to the buyer
        address seller = mintNFT.ownerOf(_tokenId);
        require(seller != address(0), "Invalid seller address");
        require(seller != msg.sender, "You cannot buy your own NFT");
        mintNFT.safeTransferFrom(seller, msg.sender, _tokenId);

        // Step 3: Transfer the ERC20 tokens from the contract to the seller
        require(coin.transfer(seller, price), "Token transfer to the seller failed");

        // Clear the sale offer after the successful purchase
        //Will have to do this as an event inside other contract.
        //isForSale[_tokenId] = false;
        //tokenPrice[_tokenId] = 0;
    }


    function setMintAddress(address _mintAddy) public onlyOwner {
        mintNFT = Mint_With_Sell(_mintAddy);
    }

    function setCoinAddress(address _coinAddy)  public onlyOwner {
        coin = CustomCoin(_coinAddy);
    }

}