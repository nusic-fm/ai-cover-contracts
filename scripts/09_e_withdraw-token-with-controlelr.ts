import { ethers, network } from "hardhat";
import { AICoverToken, AICoverToken__factory, AICoverTokenController, AICoverTokenController__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const AICoverTokenController:AICoverTokenController__factory = await ethers.getContractFactory("AICoverTokenController");
  const aiCoverTokenController:AICoverTokenController = await AICoverTokenController.attach(addresses[network.name].aiCoverTokenController);
  await aiCoverTokenController.deployed();

  console.log("AICoverTokenController Address :", aiCoverTokenController.address);

  const AICoverToken:AICoverToken__factory = await ethers.getContractFactory("AICoverToken");
  const aiCoverToken:AICoverToken = await AICoverToken.attach(addresses[network.name].aiCoverToken);
  await aiCoverToken.deployed();

  console.log("AICoverToken Address :", aiCoverToken.address);

  const voiceId = "hello-taylor";

  const currentHoldingsByVoiceId = await aiCoverTokenController.currentHoldingsByVoiceId(voiceId);
  console.log("currentHoldingsByVoiceId = ",currentHoldingsByVoiceId);
/*
  const txt1 = await aiCoverToken.approve(owner.address,currentHoldingsByVoiceId);
  console.log("approve txt1.hash = ",txt1.hash);
  const receipt1 = await txt1.wait();
  console.log("approve receipt1 = ",receipt1);
*/

  const txt2 = await aiCoverTokenController.withdraw("hello-taylor");
  console.log("withdraw txt2.hash = ",txt2.hash);
  const receipt2 = await txt2.wait();
  console.log("withdraw receipt2 = ",receipt2);
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
