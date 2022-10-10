const { ethers } = require("hardhat");

async function main() {
    const metadataURL = "ipfs://QmT7TetpfcDK5RT2j1NUT3vf1RTGgcqo15YD1FnDyoHcVT"
  // Load NFT contract
  const DonkeyNFTFactory = await ethers.getContractFactory("DonkeyNFTs");

  // Deploy the contracts
  const donkNftContract = await DonkeyNFTFactory.deploy(metadataURL);
  await donkNftContract.deployed()

  // princt the address of the NFT contract 
  console.log("Donkey NFT deployed to: ", donkNftContract.address);

  // load market place 
  const DonkeyMarketFactory = await ethers.getContractFactory(
    "DonkeyMarket"
  );

  // deploy 
  const donkeyMarketContract = await DonkeyMarketFactory.deploy()

  await donkeyMarketContract.deployed()
  console.log("NFT Marketplace deployed to: ", donkeyMarketContract.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1)
  })
