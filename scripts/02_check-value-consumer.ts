import { ethers, network } from "hardhat";
import { AICoverDataConsumer, AICoverDataConsumer__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverDataConsumer:AICoverDataConsumer__factory = await ethers.getContractFactory("AICoverDataConsumer");
  const aiCoverDataConsumer:AICoverDataConsumer = await AICoverDataConsumer.attach(addresses[network.name].aiCoverDataConsumer);
  await aiCoverDataConsumer.deployed();

  console.log("AICoverDataConsumer Address:", aiCoverDataConsumer.address);

  const coverName = await aiCoverDataConsumer.coverName();
  const playtime = await aiCoverDataConsumer.playtime();
  const numberOfRecords = await aiCoverDataConsumer.numberOfRecords();
  console.log("CoverName = ",coverName);
  console.log("Playtime = ",playtime);
  console.log("NumberOfRecords = ",numberOfRecords);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
