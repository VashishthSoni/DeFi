//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Interface/IERC20.sol";
import "./Interface/IWETH.sol";
import "./Interface/IUniswapV2Router.sol";

contract swapWETHtoDAI {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IUniswapV2Router private router = IUniswapV2Router(UNISWAP_V2_ROUTER);
    IERC20 private weth = IERC20(WETH);
    IERC20 private dai = IERC20(DAI);

    function swapWETHtoDAISingleHop(uint256 amountIn, uint256 amountOutMin) external returns (uint256 amountOut) {
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = WETH;
        path[1] = DAI;

        uint256[] memory amounts =
            router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp);
        return amounts[1];
    }
}
