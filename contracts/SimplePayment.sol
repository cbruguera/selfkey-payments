pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract SimplePayment {
    using SafeERC20 for StandardToken;

    StandardToken public token;

    event PaymentInitiated(address sender, address recipient, uint256 amount, bytes32 serviceID);

    constructor(address _token) public {
        require(_token != address(0), "Invalid token address");
        token = StandardToken(_token);
    }

    function makePayment(address recipient, uint256 amount, bytes32 serviceID) public {
        emit PaymentInitiated(msg.sender, recipient, amount, serviceID);
        token.safeTransferFrom(msg.sender, recipient, amount);
    }
}
