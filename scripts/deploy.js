const hre = require("hardhat");

async function main() {
  const CoriToken = await hre.ethers.getContractFactory("CoriToken");
  const coriToken = await CoriToken.deploy(100000000, 50);

  await coriToken.deployed();

  console.log("CoriToken deployed: ", coriToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
