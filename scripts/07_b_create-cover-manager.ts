import { ethers, network } from "hardhat";
import { AICoverManagerFactory, AICoverManagerFactory__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverManagerFactory:AICoverManagerFactory__factory = await ethers.getContractFactory("AICoverManagerFactory");
  const aiCoverManagerFactory:AICoverManagerFactory = await AICoverManagerFactory.attach(addresses[network.name].aiCoverManagerFactory);
  await aiCoverManagerFactory.deployed();

  console.log("AICoverManagerFactory Address :", aiCoverManagerFactory.address);

  const txt = await aiCoverManagerFactory.createAICoverManager("URL","Hello","hello-world");
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
