pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

/**
 *  A mock ERC20 token used for testing.
 */
contract MockToken is StandardToken {
    string public constant name = 'MockToken';
    string public constant symbol = 'MCK';
    uint256 public constant decimals = 18;

    /**
     *  Give an address an arbitrary amount of tokens.
     *  @param recipient — the address to give tokens to.
     *  @param amount — the amount of tokens to give.
     */
    function freeMoney(address recipient, uint amount) external {
        require(recipient != address(0));
        balances[recipient] = amount;
    }
}
