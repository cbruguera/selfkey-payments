pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract SimplePayment {
    using SafeERC20 for ERC20;

    ERC20 public token;

    event PaymentInitiated(address sender, address recipient, uint256 amount, bytes32 serviceID);

    constructor(address _token) public {
        require(_token != address(0), "Invalid token address");
        token = ERC20(_token);
    }

    function makePayment(address recipient, uint256 amount, bytes32 serviceID) public {
        emit PaymentInitiated(msg.sender, recipient, amount, serviceID);
        token.safeTransferFrom(msg.sender, recipient, amount);
    }
}
