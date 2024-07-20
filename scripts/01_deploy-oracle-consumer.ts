import { ethers, network } from "hardhat";
import { AICoverDataConsumer, AICoverDataConsumer__factory } from "../typechain-types";

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverDataConsumer:AICoverDataConsumer__factory = await ethers.getContractFactory("AICoverDataConsumer");
  // Ethereum Sepolia Testnet
  //const aiCoverDataConsumer:AICoverDataConsumer = await AICoverDataConsumer.deploy("0xf1960569d1b4a23c34109d9341af6496ed90c0c3");

  //BNB Smart Chain Testnet
  const aiCoverDataConsumer:AICoverDataConsumer = await AICoverDataConsumer.deploy("0x83857865971e941933dd36ebbf9475a867f67ca6");
  
  await aiCoverDataConsumer.deployed();

  console.log("AICoverDataConsumer deployed to:", aiCoverDataConsumer.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
