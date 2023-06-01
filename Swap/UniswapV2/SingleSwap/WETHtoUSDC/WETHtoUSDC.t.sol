//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "../src/WETHtoUSDC.sol";

contract WETHtoUSDCTest is Test {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    swapWETHtoUSDC private swap = new swapWETHtoUSDC();
    IWETH private weth = IWETH(WETH);
    IERC20 private usdc = IERC20(USDC);

    function setUp() external {}

    function testSwapWETHtoUSDCSingleHop() external {
        weth.deposit{value: 1e18}();
        weth.approve(address(swap), 1e18);

        uint256 usdcAmountOutMin = 1;
        uint256 usdcAmountOut = swap.swapWETHtoUSDCSingleHop(1e18, usdcAmountOutMin);
        assertGe(usdcAmountOut, usdcAmountOutMin, "Amount out < min");
        console.log("USDC :", usdcAmountOut / 1e6); // 1e6 = 1 usdc
    }
}
