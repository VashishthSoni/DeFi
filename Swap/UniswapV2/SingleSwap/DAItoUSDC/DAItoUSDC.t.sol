//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/DAItoUSDC.sol";
import "forge-std/src/Test.sol";
import "../src/WETHtoDAI.sol";

contract swapDAItoUSDCTest is Test {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdc = IERC20(USDC);

    swapDAItoUSDC private swapDtU = new swapDAItoUSDC();
    swapWETHtoDAI private swapWtD = new swapWETHtoDAI();

    function setUp() external {}

    function testSwapDAItoUSDCSingleHop() external {
        weth.deposit{value: 1e18}();
        weth.approve(address(swapWtD), 1e18);

        uint256 daiAmountOutMin = 1;
        uint256 daiAmountOut = swapWtD.swapWETHtoDAISingleHop(1e18, daiAmountOutMin);
        assertGe(daiAmountOut, daiAmountOutMin, "Amount out < Min");
        console.log("DAI :", daiAmountOut / 1e18);
        dai.approve(address(swapDtU), daiAmountOut);
        uint256 usdcAmountOutMin = 1;
        uint256 usdcAmountOut = swapDtU.swapDAItoUSDCSingleHop(daiAmountOut, usdcAmountOutMin);
        console.log("USDC :", usdcAmountOut / 1e6);
        assertGe(usdcAmountOut, usdcAmountOutMin, "amount out < min");
    }
}
