require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      allowUnlimitedContractSize: true
    },
    localhost: {
      chainId: 31337,
      allowUnlimitedContractSize: true
    },
    goerli: {
      url: process.env.ALCHEMY_API,
      accounts: [process.env.PRIVATE_KEY],
    }

    // goerli: {
    //   url: 'https://goerli.ethereum.coinbasecloud.net',
    //   user: process.env.COINBASE_USER,
    //   password: process.env.COINBASE_PASSWORD,
    //   accounts: [process.env.PRIVATE_KEY],
    // }
  }
};