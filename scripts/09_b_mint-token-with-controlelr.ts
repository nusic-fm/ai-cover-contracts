import { ethers, network } from "hardhat";
import { AICoverTokenController, AICoverTokenController__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverTokenController:AICoverTokenController__factory = await ethers.getContractFactory("AICoverTokenController");
  const aiCoverTokenController:AICoverTokenController = await AICoverTokenController.attach(addresses[network.name].aiCoverTokenController);
  await aiCoverTokenController.deployed();

  console.log("AICoverTokenController Address :", aiCoverTokenController.address);

  const txt = await aiCoverTokenController.mint("hello-taylor", ethers.utils.parseEther("500"));
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
