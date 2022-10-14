const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" }); 

async function main() {
  const donkeyDNSContractFactory = await ethers.getContractFactory("DonkeyDNS");
  const donkeyDNSContract = await donkeyDNSContractFactory.deploy("betz");
  await donkeyDNSContract.deployed()
  console.log("Contract deployed to: ", donkeyDNSContract.address);

  let txn = await donkeyDNSContract.register("DonkeyKing", {value: ethers.utils.parseEther('0.1')});
  await txn.wait();
  console.log("Minted domain Doggo.betz")

  txn = await donkeyDNSContract.setRecord("DonkeyKing", "Why ape when you can Donk!")
  await txn.wait();
  console.log("Set the record for DonkeyKing")

 const address = await donkeyDNSContract.getAddress("DonkeyKing");
 console.log("Owner of domain DonkeyKing:", address)

 const balance = await ethers.provider.getBalance(donkeyDNSContract.address);
 console.log("Contract balance:", ethers.utils.formatEther(balance))


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
      console.error(error);
      process.exit(1);
  })