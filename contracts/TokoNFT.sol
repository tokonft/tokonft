// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./TokoNFTERC20.sol";

contract TokoNFT is TokoNFTERC20, ReentrancyGuard {
    using SafeMath for uint256;

    mapping(address => bool) bots;
    uint256 public maxSupply = 1 * 10**12 * 10**18;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    constructor(string memory name, string memory symbol)
        TokoNFTERC20(name, symbol)
    {
        _mint(_msgSender(), maxSupply);
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), ~uint256(0));
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        uint256 transferFeeRate = recipient == uniswapV2Pair
            ? sellFeeRate
            : (sender == uniswapV2Pair ? buyFeeRate : 0);

        if (
            transferFeeRate > 0 &&
            sender != recipientFee &&
            recipient != recipientFee
        ) {
            uint256 _fee = amount.mul(transferFeeRate).div(100);
            super._transfer(sender, recipientFee, _fee);
            amount = amount.sub(_fee);
        }

        super._transfer(sender, recipient, amount);
    }

    function withdrawForeignToken(address _tokenContract, uint256 _amount)
        external
    {
        IERC20 tokenContract = IERC20(_tokenContract);
        tokenContract.transfer(msg.sender, _amount);
    }
}
