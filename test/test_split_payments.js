const assertThrows = require("./utils/assertThrows")
const { getLog } = require("./utils/txHelpers")
const timeTravel = require("./utils/timeTravel")

const MockToken = artifacts.require("./test/MockToken.sol")
const SplitPayment = artifacts.require("./SplitPayment.sol")

contract("SplitPayment", accounts => {
  const zeroAddress = "0x0000000000000000000000000000000000000000"
  const [owner, user1, user2, user3, user4] = accounts.slice(0)
  let token, payments

  before(async () => {
    // deploy a mock token contract and instantiate staking manager
    token = await MockToken.new()
    payments = await SplitPayment.new(token.address)
    assert.notEqual(payments, null)
    assert.notEqual(payments, undefined)

    let tokenAddress = await payments.token.call()
    assert.equal(tokenAddress, token.address)

    // initialize senders' funds
    await token.freeMoney(user1, 5000)
  })

  context('Affiliate splitting', () => {
    it('needs pre-approval in order to pay through contract', async () => {
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(Number(allowance), 0)
      await assertThrows(payments.makePayment(user2, user3, 1500, web3.utils.fromAscii("serviceX"), { from: user1 }))
    })

    it('can split payment with an affiliate address', async () => {
      await token.approve(payments.address, 1000, { from: user1 })
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(allowance, 1000)

      await payments.makePayment(user2, user3, 1000, web3.utils.fromAscii("serviceX"), { from: user1 })
      let funds1 = await token.balanceOf(user1)
      let funds2 = await token.balanceOf(user2)
      let funds3 = await token.balanceOf(user3)
      assert.equal(Number(funds1), 4000)
      assert.equal(Number(funds2), 900)
      assert.equal(Number(funds3), 100)
    })

    it('does not split unless affiliate address is spcified', async () => {
      await token.approve(payments.address, 1000, { from: user1 })
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(allowance, 1000)

      await payments.makePayment(user2, zeroAddress, 1000, web3.utils.fromAscii("serviceX"), { from: user1 })
      let funds1 = await token.balanceOf(user1)
      let funds2 = await token.balanceOf(user2)
      assert.equal(Number(funds1), 3000)
      assert.equal(Number(funds2), 1900)
    })

    it('allows contract owner to change the affiliate fee', async () => {
      await payments.setAffiliateFee(50)
      let newFee = await payments.affiliateFee.call()
      assert.equal(Number(newFee), 50)

      // test split payment with new fee
      await token.approve(payments.address, 1000, { from: user1 })
      let allowance = await token.allowance.call(user1, payments.address)
      assert.equal(allowance, 1000)

      await payments.makePayment(user2, user4, 1000, web3.utils.fromAscii("serviceX"), { from: user1 })
      let funds1 = await token.balanceOf(user1)
      let funds4 = await token.balanceOf(user4)
      assert.equal(Number(funds4), 500)   // affiliate gets 50%
    })

    it('non-owner addresses cannot change the affiliate fee', async () => {
      await assertThrows(payments.setAffiliateFee(60, { from: user1 }))
      let newFee = await payments.affiliateFee.call()
      assert.equal(Number(newFee), 50)
    })
  })
})
