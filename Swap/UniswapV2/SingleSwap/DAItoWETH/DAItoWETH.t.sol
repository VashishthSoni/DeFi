//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "../src/DAItoWETH.sol";
import "../src/WETHtoDAI.sol";

contract swapDAItoWETHTest is Test {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);

    swapWETHtoDAI private swap = new swapWETHtoDAI();
    swapDAItoWETH private swapDtW = new swapDAItoWETH();

    function setUp() external {}

    function testswapDAItoWETHSingleHop() external {
        //Swap WETH -> DAI
        weth.deposit{value: 1e18}();
        weth.approve(address(swap), 1e18);

        uint256 daiAmountMin = 1;
        uint256 daiAmountOut = swap.swapWETHtoDAISingleHop(1e18, daiAmountMin);
        assertGe(daiAmountOut, daiAmountMin, "amount out < min");
        console.log("DAI :", daiAmountOut / 1e18);

        uint256 daiAmountIn = daiAmountOut;
        dai.approve(address(swapDtW), daiAmountOut);
        uint256 wethOutMin = 1;
        uint256 wethOut = swapDtW.swapDAItoWETHSingleHop(daiAmountIn, wethOutMin);
        console.log("WETH :", wethOut);
        // assertGe(wethOutMin,wethOut,"Amount out < Min");
    }
}
