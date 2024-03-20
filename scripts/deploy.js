const hre = require("hardhat");

async function main() {
  const gt = await hre.ethers.getContractFactory("gyaanToken");
  const gyaantok = await gt.deploy(100000000, 50);
  await gyaantok.waitForDeployment();
  console.log("token contract deployed= ", gyaantok.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
