import { ethers, network } from "hardhat";
import { AICoverNFT, AICoverNFT__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverNFT:AICoverNFT__factory = await ethers.getContractFactory("AICoverNFT");
  const aiCoverNFT:AICoverNFT = await AICoverNFT.attach(addresses[network.name].aiCoverNFT);
  await aiCoverNFT.deployed();

  console.log("AICoverNFT Address to:", aiCoverNFT.address);

  const txt = await aiCoverNFT.updateSplit([owner.address, "0x07C920eA4A1aa50c8bE40c910d7c4981D135272B" ],[2400,5000]);
  console.log("txt.hash = ",txt.hash);
  const receipt = await txt.wait();
  console.log("receipt done");
  //console.log("receipt = ",receipt);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
