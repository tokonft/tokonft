const TKNFT = artifacts.require("TKNFT");

module.exports = function (deployer) {
  deployer.deploy(TKNFT);
};
