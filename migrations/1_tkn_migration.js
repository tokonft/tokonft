const TokoNFT = artifacts.require("TokoNFT");

module.exports = function (deployer) {
  deployer.deploy(TokoNFT, 'TokoNFT', 'TKN');
};