pragma solidity 0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract MintNFTMarketplace is ERC721Full {
    using SafeERC20 for IERC20;

    address public owner;
    mapping(uint256 => uint256) public nftPrices;

    IERC20 public paymentToken;

    event NFTPriceSet(uint256 tokenId, uint256 price);
    event NFTPurchased(uint256 tokenId, address buyer);

    constructor(address _paymentToken) ERC721Full("New NFT", "NFT") public {
        owner = msg.sender;
        paymentToken = IERC20(_paymentToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function setNFTPrice(uint256 tokenId, uint256 price) external onlyOwner {
        require(ownerOf(tokenId) == address(this), "Contract must own the NFT");
        nftPrices[tokenId] = price;

        // Approve the contract to transfer the NFT
        approve(address(this), tokenId);

        emit NFTPriceSet(tokenId, price);
    }

    function purchaseNFT(uint256 tokenId) external {
        require(nftPrices[tokenId] > 0, "NFT price not set");
        uint256 price = nftPrices[tokenId];
        require(paymentToken.allowance(msg.sender, address(this)) >= price, "Insufficient allowance");

        // Transfer payment from buyer to the contract
        paymentToken.safeTransferFrom(msg.sender, address(this), price);

        // Transfer NFT from contract to buyer
        safeTransferFrom(address(this), msg.sender, tokenId);

        // Emit event for NFT purchase
        emit NFTPurchased(tokenId, msg.sender);
    }

    function mint(address _to, string memory _tokenURI) public returns (bool) {
        uint256 _tokenId = totalSupply().add(1);
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
        return true;
    }
}
