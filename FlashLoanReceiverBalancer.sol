pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@balancer-labs/v2-vault/contracts/interfaces/IVault.sol";
import "@balancer-labs/v2-vault/contracts/interfaces/IFlashLoanRecipient.sol";

contract FlashLoanRecipient is IFlashLoanRecipient {
    IVault private constant vault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);


    address private constant WETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address private constant BAL = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;
    address private constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address private constant WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;


    enum SwapKind { GIVEN_IN, GIVEN_OUT }

struct SingleSwap {
   bytes32 poolId;
   SwapKind kind;
   IAsset assetIn;
   IAsset assetOut;
   uint256 amount;
   bytes userData;
}

    SingleSwap singleSwap = SingleSwap(0x0297e37f1873d2dab4487aa67cd56b58e2f27875, GIVEN_IN, WETH, BAL, 100, "");

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
        require(IVault(msg.sender) == vault);
        
        //Do stuff with tokens here
        
    }

}