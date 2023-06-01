//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "../src/USDCtoDAI.sol";
import "../src/WETHtoUSDC.sol";

contract swapUSDCtoDAItest is Test{
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdc = IERC20(USDC);

    swapUSDCtoDAI private swapUtD = new swapUSDCtoDAI();
    swapWETHtoUSDC private swapWtU = new swapWETHtoUSDC();

    function setUp() external{}

    function testSwapUSDCtoDAISingleHop()external{
        weth.deposit{value: 1e18}();
        weth.approve(address(swapWtU),1e18);

        uint usdcAmountOutMin = 1;
        uint usdcAmountOut = swapWtU.swapWETHtoUSDCSingleHop(1e18, usdcAmountOutMin);
        console.log("USDC : ",usdcAmountOut/1e6);
        assertGe(usdcAmountOut,usdcAmountOutMin,"Amount out < min");

        usdc.approve(address(swapUtD),usdcAmountOut);
        uint daiOutMin = 1;
        uint daiAmountOut = swapUtD.swapUSDCtoDAISingleHop(usdcAmountOut, daiOutMin);
        console.log("DAI : ",daiAmountOut/1e18);
        assertGe(daiAmountOut,daiOutMin,"Amount out < min");
    }

}