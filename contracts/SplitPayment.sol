pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract SplitPayment is Ownable {
    using SafeERC20 for ERC20;
    using SafeMath for uint256;

    uint256 public affiliateFee = 10;   // specified as a percentage
    ERC20 public token;

    event PaymentInitiated(address sender, address recipient, uint256 amount, bytes32 serviceID);
    event SetAffiliateFee(uint256 _fee);

    constructor(address _token) public {
        require(_token != address(0), "Invalid token address");
        token = ERC20(_token);
    }

    function makePayment(address recipient, address affiliate, uint256 amount, bytes32 serviceID)
        public
    {
        uint256 fee = 0;
        uint256 recipientAmount = amount;   // can amount be reused?

        if (affiliate != address(0)) {
            fee = amount.mul(affiliateFee).div(100);
            recipientAmount = amount.sub(fee);
            token.safeTransferFrom(msg.sender, affiliate, fee);
        }

        token.safeTransferFrom(msg.sender, recipient, recipientAmount);
        emit PaymentInitiated(msg.sender, recipient, recipientAmount, serviceID);
    }

    function setAffiliateFee(uint256 _fee)
        public
        onlyOwner
    {
        require(_fee <= 100, "fee must be specified as a percentage: 0 <= 100");
        affiliateFee = _fee;
        emit SetAffiliateFee(_fee);
    }
}
