var MockToken = artifacts.require("./test/MockToken.sol");

module.exports = function (deployer) {
  deployer.deploy(MockToken);
};
