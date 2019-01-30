pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract SplitPayment {
    using SafeERC20 for StandardToken;
    using SafeMath for uint256;

    uint256 public AFFILIATE_FEE = 10;
    StandardToken public token;

    event PaymentInitiated(address sender, address recipient, uint256 amount, bytes32 serviceID);

    constructor(address _token) public {
        require(_token != address(0), "Invalid token address");
        token = StandardToken(_token);
    }

    function makePayment(address recipient, address affiliate, uint256 amount, bytes32 serviceID)
        public
    {
        require(token.allowance(msg.sender, address(this)) >= amount,"Not enough tokens approved");
        uint256 fee = 0;
        uint256 recipientAmount = amount;   // can amount be reused?

        if (affiliate != address(0)) {
            fee = amount.mul(AFFILIATE_FEE).div(100);
            recipientAmount = amount.sub(fee);
            token.safeTransferFrom(msg.sender, affiliate, fee);
        }

        token.safeTransferFrom(msg.sender, recipient, recipientAmount);
        emit PaymentInitiated(msg.sender, recipient, recipientAmount, serviceID);
    }
}
