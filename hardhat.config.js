require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.19" },
      { version: "0.8.17" },
      { version: "0.8.20" },
    ],
    networks: {
      hardhat: {},
      mumbai: {
        url: process.env.INFURA_MUMBAI_TESTNET,
        accounts: [`0x${process.env.PRIVATE_KEY}`],
        chainId: 80001,
      },
    },
  },
};
