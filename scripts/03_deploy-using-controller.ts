import { ethers, network } from "hardhat";
import { AICoverContractFactory, AICoverContractFactory__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverContractFactory:AICoverContractFactory__factory = await ethers.getContractFactory("AICoverContractFactory");
  const aiCoverContractFactory:AICoverContractFactory = await AICoverContractFactory.attach(addresses[network.name].aiCoverContractFactory);
  await aiCoverContractFactory.deployed();

  console.log("AICoverContractFactory Address :", aiCoverContractFactory.address);

  const txt = await aiCoverContractFactory.deployAICoverContract("AICcover1","AIC1","songid1","userid1","songname1");
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
