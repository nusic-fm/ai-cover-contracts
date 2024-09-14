import { ethers, network } from "hardhat";
import { AICoverManager, AICoverManager__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverManager:AICoverManager__factory = await ethers.getContractFactory("AICoverManager");
  const aiCoverManager:AICoverManager = await AICoverManager.deploy("URL","Hello","hello-world");
  await aiCoverManager.deployed();

  console.log("AICoverManager deployed to:", aiCoverManager.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
