const hre = require("hardhat");

async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x4594F455A1E03F16b2089bBd22aEC7fDA9226837");

  await faucet.deployed();

  console.log("Faucet deployed: ", faucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
