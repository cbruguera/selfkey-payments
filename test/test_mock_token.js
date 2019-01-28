const assertThrows = require("./utils/assertThrows")
const { getLog } = require("./utils/txHelpers")
const timeTravel = require("./utils/timeTravel")

const MockToken = artifacts.require("./test/MockToken.sol")

contract("MockToken", accounts => {
  const [owner, user1, user2, user3] = accounts.slice(0)
  const now = new Date().getTime() / 1000

  let token

  before(async () => {
    // deploy a mock token contract and instantiate staking manager
    token = await MockToken.new()

    // initialize senders' funds
    await token.freeMoney(user1, 4000)
    await token.freeMoney(user2, 1000)
    await token.freeMoney(user3, 1000)
  })

  context("Transfers", () => {
    it("sender can transfer tokens directly", async () => {
      await token.transfer(user2, 1500, { from: user1 })
      let funds1 = await token.balanceOf(user1)
      let funds2 = await token.balanceOf(user2)
      assert.equal(Number(funds1), Number(funds2))
    })
  })
})
