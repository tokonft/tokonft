// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokoNFTERC20 is Ownable, ERC20 {
    using SafeMath for uint256;

    uint256 public sellFeeRate = 5;
    uint256 public buyFeeRate = 2;
    address public recipientFee;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function setTransferFeeRate(uint256 _sellFeeRate, uint256 _buyFeeRate)
        public
        onlyOwner
    {
        sellFeeRate = _sellFeeRate;
        buyFeeRate = _buyFeeRate;
    }

    function setTransferFeeAddress(address _recipientFee) public onlyOwner {
        recipientFee = _recipientFee;
    }
}
