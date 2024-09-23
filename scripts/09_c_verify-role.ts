import { ethers, network } from "hardhat";
import { AICoverToken, AICoverToken__factory, AICoverTokenController, AICoverTokenController__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverTokenController:AICoverTokenController__factory = await ethers.getContractFactory("AICoverTokenController");
  const aiCoverTokenController:AICoverTokenController = await AICoverTokenController.attach(addresses[network.name].aiCoverTokenController);
  await aiCoverTokenController.deployed();
  
  console.log("AICoverTokenController Address :", aiCoverTokenController.address);


  const AICoverToken:AICoverToken__factory = await ethers.getContractFactory("AICoverToken");
  const aiCoverToken:AICoverToken = await AICoverToken.attach(addresses[network.name].aiCoverToken);
  await aiCoverToken.deployed();

  console.log("AICoverToken Address :", aiCoverToken.address);
/*
  const isRole = await aiCoverTokenController.hasRole(aiCoverTokenController.MINTER_ROLE(),owner.address);
  console.log("is role = ",isRole);
*/
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
