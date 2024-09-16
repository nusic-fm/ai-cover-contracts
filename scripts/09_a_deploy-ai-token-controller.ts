import { ethers, network } from "hardhat";
import { AICoverToken, AICoverToken__factory, AICoverTokenController, AICoverTokenController__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverTokenController:AICoverTokenController__factory = await ethers.getContractFactory("AICoverTokenController");
  const aiCoverTokenController:AICoverTokenController = await AICoverTokenController.deploy(addresses[network.name].aiCoverToken);
  await aiCoverTokenController.deployed();

  console.log("AICoverTokenController deployed to:", aiCoverTokenController.address);


  const AICoverToken:AICoverToken__factory = await ethers.getContractFactory("AICoverToken");
  const aiCoverToken:AICoverToken = await AICoverToken.attach(addresses[network.name].aiCoverToken);
  await aiCoverToken.deployed();

  console.log("AICoverToken Address :", aiCoverToken.address);

  const txt = await aiCoverToken.setMinter(aiCoverTokenController.address);
  console.log("txt.hash = ",txt.hash);
  const receipt = await txt.wait();
  console.log("receipt = ",receipt);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
