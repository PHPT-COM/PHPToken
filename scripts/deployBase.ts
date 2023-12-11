const hre = require("hardhat");
let fs = require("fs");
let deployedContractsv1 = require("../deployment/v1.json");
let deploymentConfig = require("../config/config.json");

async function deployBase() {
  console.log("------------------------------ Initial Setup Started ------------------------------");

  const network = await hre.getChainId();
  deployedContractsv1[network] = {};
 // const wEthAddress = deploymentConfig[network].wETHAddress;
 // const trustedForwarder = deploymentConfig[network].trustedForwarder;

  // console.log("------------------------------ Initial Setup Ended ------------------------------");

  // console.log("--------------- Contract Deployment Started ---------------");

  // const PHPToken = await hre.ethers.getContractFactory("PHPToken");
  // const PHPTokenProxy = await hre.upgrades.deployProxy(PHPToken,{ kind: "uups" });
  // console.log("Contract PHPTokenProxy deployed to: ", PHPTokenProxy.address);


  // // console.log("Contract PackageProxy deployed to: ", PHPTokenProxy.address);

  // console.log("------------------------------ Contract Deployment Ended ------------------------------");
  // console.log("------------------------------ Deployment Storage Started ------------------------------");

  // deployedContractsv1[network] = {
  //   PHPToken: PHPTokenProxy.address
  // };

  await hre.run("verify:verify", {
    address: "",
    network: hre.ethers.provider.network,
  })
  fs.writeFileSync("./deployment/v1.json", JSON.stringify(deployedContractsv1));

  console.log("------------------------------ Deployment Storage Ended ------------------------------");
}

deployBase()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
