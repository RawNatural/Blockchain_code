// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.0;

//old ones
import "@balancer-labs/v2-vault/contracts/interfaces/IVault.sol";
import "@balancer-labs/v2-vault/contracts/interfaces/IFlashLoanRecipient.sol";

//new ones
//import "https://github.com/balancer-labs/balancer-v2-monorepo/blob/ad3ece6be2ee42e00cd64c52f4063676bdc65928/pkg/interfaces/contracts/vault/IFlashLoanRecipient.sol";
//import "https://github.com/balancer-labs/balancer-v2-monorepo/blob/ad3ece6be2ee42e00cd64c52f4063676bdc65928/pkg/interfaces/contracts/vault/IVault.sol";


contract FlashLoanRecipient is IFlashLoanRecipient {
    IVault private constant vault = "0xBA12222222228d8Ba445958a75a0704d566BF2C8";

/*
    address private constant WETH = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";
    address private constant BAL = "0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3";
    address private constant USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
    address private constant WMATIC = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";
*/
/*
    SingleSwap singleSwap = SingleSwap("0x0297e37f1873d2dab4487aa67cd56b58e2f27875", "Out Given In", WETH, BAL, 100, "");
*/
    function makeFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external {
      vault.flashLoan(this, tokens, amounts, userData);
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external override {
        require(msg.sender == vault);

        //Use funds here



        // Return all tokens to the pool
        require(address(vault).transfer(address(vault), amounts), "Transfer of tokens failed");
    }

    

}