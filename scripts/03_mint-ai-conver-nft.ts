import { ethers, network } from "hardhat";
import { AICoverNFT, AICoverNFT__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverNFT:AICoverNFT__factory = await ethers.getContractFactory("AICoverNFT");
  const aiCoverNFT:AICoverNFT = await AICoverNFT.attach(addresses[network.name].aiCoverNFT);
  //await aiCoverNFT.deployed();

  console.log("AICoverNFT Address to:", aiCoverNFT.address);

  const txt = await aiCoverNFT.mintAICover("voiceid1","voicename1","voiceModelCreatorId1","coverCreatorId1", "tokenuri1");
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
