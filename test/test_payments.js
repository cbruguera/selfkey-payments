const assertThrows = require("./utils/assertThrows")
const { getLog } = require("./utils/txHelpers")
const timeTravel = require("./utils/timeTravel")

const MockToken = artifacts.require("./test/MockToken.sol")
const SimplePayment = artifacts.require("./SimplePayment.sol")

contract("SimplePayment", accounts => {
  const [owner, user1, user2, user3] = accounts.slice(0)
  let token, payments

  before(async () => {
    // deploy a mock token contract and instantiate staking manager
    token = await MockToken.new()
    payments = await SimplePayment.new(token.address)
    assert.notEqual(payments, null)
    assert.notEqual(payments, undefined)

    let tokenAddress = await payments.token.call()
    assert.equal(tokenAddress, token.address)

    // initialize senders' funds
    await token.freeMoney(user1, 4000)
    await token.freeMoney(user2, 1000)
    await token.freeMoney(user3, 1000)
  })

  context('Simple payments', () => {
    it('needs pre-approval in order to pay through contract', async () => {
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(Number(allowance), 0)
      await assertThrows(payments.makePayment(user2, 1500, web3.utils.fromAscii("serviceX"), { from: user1 }))
    })

    it('users can make simple payments through SimplePayment contract', async () => {
      await token.approve(payments.address, 1500, { from: user1 })
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(allowance, 1500)

      await payments.makePayment(user2, 1500, web3.utils.fromAscii("serviceX"), { from: user1 })
      let funds1 = await token.balanceOf(user1)
      let funds2 = await token.balanceOf(user2)
      assert.equal(Number(funds1), Number(funds2))
    })
  })
})
