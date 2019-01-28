var PaymentGateway = artifacts.require("./PaymentGateway.sol");
var tokenAddress = '0x544d783D17af7D1861ad20eE7b1d567890c42223'

module.exports = function (deployer) {
  deployer.deploy(PaymentGateway, tokenAddress);
};
