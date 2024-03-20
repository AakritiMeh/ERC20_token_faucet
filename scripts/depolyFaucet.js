const hre = require("hardhat");

async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy(process.env.TOKEN_CONTRACT_ADDRESS);
  await faucet.waitForDeployment();
  console.log("token contract deployed= ", faucet.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
