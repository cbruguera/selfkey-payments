pragma solidity ^0.4.23;

import "zos-lib/contracts/Initializable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract PaymentGateway is Initializable {
    using SafeERC20 for StandardToken;

    StandardToken public token;
    //mapping(bytes32 => address) public implementations;

    event PaymentInitiated(address sender, address recipient, uint256 amount, bytes32 serviceID);

    function initialize(address _token) public initializer {
        require(_token != address(0), "Invalid token address");
        token = StandardToken(_token);
    }

    /*constructor(address _token) public {
        require(_token != address(0), "Invalid token address");
        token = StandardToken(_token);
    }*/

    function makePayment(address recipient, uint256 amount, bytes32 serviceID) public {
        emit PaymentInitiated(msg.sender, recipient, amount, serviceID);
        token.safeTransferFrom(msg.sender, recipient, amount);
    }

    //... implement routing directory logic
}
