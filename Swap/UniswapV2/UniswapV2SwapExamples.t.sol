// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "forge-std/src/console.sol";

import "../src/UniswapV2SwapExamples.sol";

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

contract UniswapV2SingleSwapTest is Test {
    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdc = IERC20(USDC);

    UniswapV2SwapExamples private uni = new UniswapV2SwapExamples();

    function setUp() public {}

    // Swap WETH -> DAI
    function testSwapSingleHopExactAmountIn() public {
        uint256 wethAmount = 1e18;
        weth.deposit{value: wethAmount}();
        weth.approve(address(uni), wethAmount);

        uint256 daiAmountMin = 1;
        uint256 daiAmountOut = uni.swapSingleHopExactAmountIn(wethAmount, daiAmountMin);
        //1e18 = 1 DAI
        console.log("DAI", daiAmountOut / 1e18);
        assertGe(daiAmountOut, daiAmountMin, "amount out < min");
    }

    // WETH -> DAI -> USDC
    function testSwapMultiHopExactAmountIn() public {
        // WETH -> DAI
        uint256 wethAmount = 1e18;
        weth.deposit{value: wethAmount}();
        weth.approve(address(uni), wethAmount);

        uint256 daiAmountOutMin = 1;
        uint256 daiAmountOut = uni.swapSingleHopExactAmountIn(wethAmount, daiAmountOutMin);
        console.log("(1)DAI:", daiAmountOut / 1e18);

        // DAI -> USDC
        uint256 daiAmountIn = daiAmountOut;
        dai.approve(address(uni), daiAmountIn);

        uint256 usdcAmountOutMin = 1;
        uint256 usdcAmountOut = uni.swapMultiHopExactAmountIn(daiAmountIn, usdcAmountOutMin);
        //1e6 = 1 USDC
        console.log("(2)USDC:", usdcAmountOut / 1e6);
        assertGe(usdcAmountOut, usdcAmountOutMin, "amount out < min");
    }

    // WETH -> DAI
    function testSwapSingleHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        weth.deposit{value: wethAmount}();
        weth.approve(address(uni), wethAmount);

        uint256 daiAmountDesired = 1e18;
        uint256 daiAmountOut = uni.swapSingleHopExactAmountOut(daiAmountDesired, wethAmount);

        //Amount of DAI swapped will be same as weth amount because extra weth are refunded
        console.log("DAI", daiAmountOut / 1e18);

        assertEq(daiAmountOut, daiAmountDesired, "amount out != amount out desired");
    }

    // WETH -> DAI -> USDC
    function testSwapMultiHopExactAmountOut() public {
        uint256 wethAmount = 1e18;
        weth.deposit{value: wethAmount}();
        weth.approve(address(uni), wethAmount);

        // Desired Amount = 100 DAI tokens
        uint256 daiOutDesired = 1e18 * 100;
        uint256 daiAmountOut = uni.swapSingleHopExactAmountOut(daiOutDesired, wethAmount);

        dai.approve(address(uni), daiAmountOut);
        
        // Desired Amount = 99 USDC tokens
        uint256 amountOutDesired = 1e6 * 99;
        uint256 amountOut = uni.swapMultiHopExactAmountOut(amountOutDesired, daiAmountOut);

        console.log("USDC", amountOut/1e6);
        assertEq(amountOut, amountOutDesired, "amount out != amount out desired ");
    }
}