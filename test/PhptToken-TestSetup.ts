import hre from "hardhat";
import { PHPTTokentestCases } from "./PhptToken-TestCases";

describe("Testing EmberswardNFTv1 Contract", function () {
  beforeEach(async function () {
    this.accounts = await hre.ethers.getSigners();
    this.trustedForwarder = "";
    this.PHPToken = await hre.ethers.getContractFactory("PHPToken");
    this.PHPTokenInstance = await hre.upgrades.deployProxy(this.PHPToken, [this.trustedForwarder], { kind: "uups" });
    // console.log("Contract NFTProxy deployed to: ", this.nftInstance.address);
  });

  describe("Started Testing", function () {
    PHPTTokentestCases();
  });
});
