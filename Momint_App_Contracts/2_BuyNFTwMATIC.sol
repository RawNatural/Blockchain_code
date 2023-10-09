// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "./1_Mint_With_Sell.sol";

contract BuyNFTwMATIC {

    address private conOwner;

    Mint_With_Sell mintNFT;

    modifier onlyOwner() {
        require(msg.sender == conOwner, "Only the owner can call this function");
        _;
    }

    constructor () public {
        conOwner = msg.sender;
    }

    function buy(uint256 _tokenId) public payable {
        uint256 price = mintNFT.getTokenPrice(_tokenId);
        bool onSale = mintNFT.getIfOnSale(_tokenId);
        require(onSale, "Token Not For Sale");
        require(price > 0, "Invalid token price");


        // Step 2: Transfer the ownership of the NFT from the seller to the buyer
        address seller = mintNFT.ownerOf(_tokenId);
 
        require(seller != address(0), "Invalid seller address");
        require(seller != msg.sender, "You cannot buy your own NFT");
        mintNFT.safeTransferFrom(seller, msg.sender, _tokenId);


        //Set address to payable (note in 0.6.0 and higher, can use payable(seller)
        address payable sellerPayable = address(uint160(seller));
        // Step 3: Transfer the ERC20 tokens from the contract to the seller
        transferMatic(sellerPayable, price);

        // Refund any excess Ether back to the msg.sender
        uint256 excessAmount = msg.value - price;
        if (excessAmount > 0) {
        msg.sender.transfer(excessAmount);
    }

        // Clear the sale offer after the successful purchase
        mintNFT.itemBought(_tokenId);
    }



    function setMintAddress(address _mintAddy) public onlyOwner {
        mintNFT = Mint_With_Sell(_mintAddy);
    }

    function transferMatic(address payable recipient, uint256 amount) public payable {
        require(msg.value > 0, "Must send Matic with a non-zero value");
        require(msg.value >= amount, "Value sent must cover price cost");
        recipient.transfer(amount);
    }


}