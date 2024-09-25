import { ethers, network } from "hardhat";
import { AICoverToken, AICoverToken__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverToken:AICoverToken__factory = await ethers.getContractFactory("AICoverToken");
  //const aiCoverToken:AICoverToken = await AICoverToken.deploy(owner.address, owner.address, owner.address);
  const aiCoverToken:AICoverToken = await AICoverToken.deploy();
  await aiCoverToken.deployed();

  console.log("AICoverToken deployed to:", aiCoverToken.address);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
