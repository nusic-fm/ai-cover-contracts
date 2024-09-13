import { ethers, network } from "hardhat";
import { AIVoiceNFTFactory, AIVoiceNFTFactory__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AIVoiceNFTFactory:AIVoiceNFTFactory__factory = await ethers.getContractFactory("AIVoiceNFTFactory");
  const aiVoiceNFTFactory:AIVoiceNFTFactory = await AIVoiceNFTFactory.attach(addresses[network.name].aiVoiceNFTFactory);
  await aiVoiceNFTFactory.deployed();

  console.log("AIVoiceNFTFactory Address :", aiVoiceNFTFactory.address);

  const txt = await aiVoiceNFTFactory.createAICoverManager("NFT F1","F1","RVC URL", "hello-world","hello-taylor");
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
