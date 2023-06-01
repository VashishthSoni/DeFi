//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/src/Test.sol";
import "../src/WETHtoDAI.sol";

contract swapWETHtoDAITest is Test {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IWETH private weth = IWETH(WETH);
    IERC20 private dai = IERC20(DAI);

    swapWETHtoDAI private swap = new swapWETHtoDAI();

    function setUp() external {}

    function testswapWETHtoDAISingleHop() external {
        weth.deposit{value: 1e18}();
        weth.approve(address(swap), 1e18);

        uint256 daiAmountOutMin = 1;
        uint256 daiAmountOut = swap.swapWETHtoDAISingleHop(1e18, daiAmountOutMin);
        assertGe(daiAmountOut, daiAmountOutMin, "Amount out < Min ");
        console.log("DAI : ", daiAmountOut / 1e18); //1e18 = 1 token dai
    }

    function testFailswapWETHtoDAISingleHopAgain() external {
        weth.deposit{value: 1e18}();
        weth.approve(address(swap), 1e18 * 10);

        uint256 daiAmountOutMin = 1;
        uint256 daiAmountOut = swap.swapWETHtoDAISingleHop(1e18 * 10, daiAmountOutMin);
        assertGe(daiAmountOut, daiAmountOutMin, "Amount out < Min ");
        console.log("DAI : ", daiAmountOut / 1e18); //1e18 = 1 token dai
    }
}
