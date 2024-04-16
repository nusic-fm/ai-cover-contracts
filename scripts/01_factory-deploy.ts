import { ethers, network } from "hardhat";
import { AICoverContractFactory, AICoverContractFactory__factory } from "../typechain-types";

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverContractFactory:AICoverContractFactory__factory = await ethers.getContractFactory("AICoverContractFactory");
  const aiCoverContractFactory:AICoverContractFactory = await AICoverContractFactory.deploy();
  await aiCoverContractFactory.deployed();

  console.log("AICoverContractFactory deployed to:", aiCoverContractFactory.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
