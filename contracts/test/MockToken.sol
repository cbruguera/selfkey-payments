pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';


/**
 *  A mock ERC20 token used for testing.
 */
contract MockToken is ERC20 {
    /**
     *  Give an address an arbitrary amount of tokens.
     *  @param recipient — the address to give tokens to.
     *  @param amount — the amount of tokens to give.
     */
    function freeMoney(address recipient, uint amount) external {
        require(recipient != address(0));
        //_balances[recipient] = amount;
        _mint(recipient, amount);
    }
}
