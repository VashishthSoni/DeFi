//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Interface/IERC20.sol";
import "./Interface/IUniswapV2Router.sol";

contract LiquidityWETHandUSDT {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    function addLiquidity(address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB)
        external
        returns (uint256)
    {
        safeTransferFrom(IERC20(_tokenA), msg.sender, address(this), _amountA);
        safeTransferFrom(IERC20(_tokenB), msg.sender, address(this), _amountB);

        safeApprove(IERC20(_tokenA), ROUTER, _amountA);
        safeApprove(IERC20(_tokenB), ROUTER, _amountB);

        (uint256 amountA, uint256 amountB, uint256 liquidity) = IUniswapV2Router(ROUTER).addLiquidity(
            _tokenA, _tokenB, _amountA, _amountB, 1, 1, address(this), block.timestamp
        );
        return liquidity;
    }

    function removeLiquidity(address _tokenA, address _tokenB) external returns (uint256, uint256) {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);
        uint256 liquidity = IERC20(pair).balanceOf(address(this));
        safeApprove(IERC20(pair), ROUTER, liquidity);

        (uint256 amountA, uint256 amountB) =
            IUniswapV2Router(ROUTER).removeLiquidity(_tokenA, _tokenB, liquidity, 1, 1, msg.sender, block.timestamp);
        return (amountA, amountB);
    }

    function safeTransferFrom(IERC20 token, address sender, address recipient, uint256 amount) internal {
        (bool success, bytes memory returnData) =
            address(token).call(abi.encodeCall(IERC20.transferFrom, (sender, recipient, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Transfer from fail");
    }

    function safeApprove(IERC20 token, address spender, uint256 amount) internal {
        (bool success, bytes memory returnData) = address(token).call(abi.encodeCall(IERC20.approve, (spender, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Approve fail");
    }
}
