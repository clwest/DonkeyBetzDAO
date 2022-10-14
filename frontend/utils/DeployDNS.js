import { Contract, providers, utils } from "ethers";
import Head from "next/head";
import React, { useEffect, useRef, useState } from "react";
import Web3Modal from "web3modal";
import { abi, DONKEY_DNS_ADDRESS  } from "../constants";
import styles from "../styles/Home.module.css";



export default function DonkeyDNS() { 


    const [currentAccount, setCurrentAccount] = useState('');
    const [domain, setDomain] = useState('');
    const [loading, setIsLoading] = useState(false);
    const [record, setRecord] = useState('');
    const [network, setNetwork] = useState('');
    const [editing, setEditing] = useState(false);
    const [mints, setMints] = useState([]);


      /**
   * publicMint: Mint an NFT after the presale
   */
    const mintDns = async () => {
        if (!domain) {return}
        if (domain.length < 3) {
            alert('Username must be 3 characters or longer~')
            return
        }

            // Calaculating price based on length
        const price = domain.length === 3 ? '0.5' : domain.length === 4 ? '0.3' : '0.1';
        console.log("Minting domain", domain, "with price", price);

        try {
            // We need a Signer here since this is a 'write' transaction.
            const signer = await getProviderOrSigner(true);
            // Create a new instance of the Contract with a Signer, which allows
            // update methods
            const nftContract = new Contract(DONKEY_DNS_ADDRESS , abi, signer);
            // call the mint from the contract to mint the Crypto Dev
            const tx = await nftContract.mint({
                // value signifies the cost of one crypto dev which is "0.01" eth.
                // We are parsing `0.01` string to ether using the utils library from ethers.js
                value: utils.parseEther("0.01"),
            });
            setLoading(true);
            // wait for the transaction to get mined
            await tx.wait();
            setLoading(false);
            window.alert("You successfully minted a Crypto Dev!");
        } catch (err) {
            console.error(err);
        }
    };

}