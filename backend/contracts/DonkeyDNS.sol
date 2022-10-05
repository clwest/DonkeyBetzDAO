// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

contract DonkeyDNS is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public tld;
    string _baseTokenURI;

    string svgOne = '<svg width="451" height="472" viewBox="0 0 451 472" fill="none" xmlns="http://www.w3.org/2000/svg"><g filter="url(#filter0_d_206_5)"><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="477" width="500"><feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter><rect x="4.17615" y="2.00742" width="448.87" height="468.909" transform="rotate(-0.233037 4.17615 2.00742)" fill="#92BA3C" shape-rendering="crispEdges"/><path d="M342.506 0.749327C342.506 0.749327 299.866 35.2396 281.432 89.4409C274.665 108.868 269.854 128.923 267.071 149.306C242.292 154.57 197.079 182.954 197.079 182.954L162.372 179.349L174.39 197.324L138.661 203.109L154.399 217.717L124.303 216.478L127.703 229.134L100.931 228.575L103.673 248.999L80.2331 244.667L82.9868 267.924L64.2628 264.322L63.7198 283.315L34.217 278.789L36.9654 300.74L1.43371 311.196L2.08278 470.778L178.944 470.059L245.467 355.747L209.613 310.731L222.097 300.995L266.343 356.534C270.824 360.917 275.553 364.997 278.783 366.334C296.351 373.619 331.611 374.293 347.894 383.995C357.079 389.406 368.199 410.313 378.259 413.965C380.009 414.461 381.828 414.674 383.648 414.597C392.438 414.561 406.078 411.427 406.078 411.427L418.527 423.365L430.032 413.469L399.596 382.721L410.89 371.654L443.111 404.124L445.268 402.603C445.268 402.603 454.696 349.215 448.169 333.112C440.375 313.962 402.664 290.125 391.2 272.883C381.76 258.725 374.152 224.099 363.722 210.736C353.584 197.576 332.685 177.73 311.825 164.014C321.989 146.235 330.364 127.49 336.824 108.056C355.218 53.8972 342.602 0.748936 342.602 0.748936L342.506 0.749327ZM407.843 21.8993C407.843 21.8993 386.078 33.1866 362.443 55.4068C361.65 75.0724 358.088 94.528 351.863 113.199C346.537 129.009 340.089 144.419 332.569 159.311C335.83 161.764 338.996 164.299 342.092 166.861C354.014 153.261 364.867 138.76 374.555 123.488C405.401 75.2861 407.843 21.8993 407.843 21.8993ZM323.004 233.175C326.002 233.163 328.935 234.031 331.435 235.667C333.927 237.296 335.879 239.629 337.044 242.369C338.201 245.099 338.514 248.114 337.942 251.024C337.365 253.94 335.931 256.617 333.825 258.714C331.706 260.823 329.013 262.26 326.082 262.846C323.145 263.437 320.099 263.152 317.322 262.029C314.555 260.912 312.181 259.001 310.499 256.537C308.825 254.086 307.923 251.19 307.91 248.223C307.894 244.248 309.475 240.43 312.306 237.608C315.15 234.781 318.994 233.188 323.004 233.175ZM429.499 333.187C432.159 333.177 434.377 340.061 434.412 348.644C434.447 357.226 432.257 364.129 429.501 364.14C426.746 364.151 424.638 357.239 424.603 348.698C424.568 340.156 426.716 333.186 429.375 333.175L429.499 333.187Z" fill="#108410"/><path d="M342.506 0.749327C342.506 0.749327 299.866 35.2396 281.432 89.4409C274.665 108.868 269.854 128.923 267.071 149.306C242.292 154.57 197.079 182.954 197.079 182.954L162.372 179.349L174.39 197.324L138.661 203.109L154.399 217.717L124.303 216.478L127.703 229.134L100.931 228.575L103.673 248.999L80.2331 244.667L82.9868 267.924L64.2628 264.322L63.7198 283.315L34.217 278.789L36.9654 300.74L1.43371 311.196L2.08278 470.778L178.944 470.059L245.467 355.747L209.613 310.731L222.097 300.995L266.343 356.534C270.824 360.917 275.553 364.997 278.783 366.334C296.351 373.619 331.611 374.293 347.894 383.995C357.079 389.406 368.199 410.313 378.259 413.965C380.009 414.461 381.828 414.674 383.648 414.597C392.438 414.561 406.078 411.427 406.078 411.427L418.527 423.365L430.032 413.469L399.596 382.721L410.89 371.654L443.111 404.124L445.268 402.603C445.268 402.603 454.696 349.215 448.169 333.112C440.375 313.962 402.664 290.125 391.2 272.883C381.76 258.725 374.152 224.099 363.722 210.736C353.584 197.576 332.685 177.73 311.825 164.014C321.989 146.235 330.364 127.49 336.824 108.056C355.218 53.8972 342.602 0.748936 342.602 0.748936L342.506 0.749327ZM407.843 21.8993C407.843 21.8993 386.078 33.1866 362.443 55.4068C361.65 75.0724 358.088 94.528 351.863 113.199C346.537 129.009 340.089 144.419 332.569 159.311C335.83 161.764 338.996 164.299 342.092 166.861C354.014 153.261 364.867 138.76 374.555 123.488C405.401 75.2861 407.843 21.8993 407.843 21.8993ZM323.004 233.175C326.002 233.163 328.935 234.031 331.435 235.667C333.927 237.296 335.879 239.629 337.044 242.369C338.201 245.099 338.514 248.114 337.942 251.024C337.365 253.94 335.931 256.617 333.825 258.714C331.706 260.823 329.013 262.26 326.082 262.846C323.145 263.437 320.099 263.152 317.322 262.029C314.555 260.912 312.181 259.001 310.499 256.537C308.825 254.086 307.923 251.19 307.91 248.223C307.894 244.248 309.475 240.43 312.306 237.608C315.15 234.781 318.994 233.188 323.004 233.175ZM429.499 333.187C432.159 333.177 434.377 340.061 434.412 348.644C434.447 357.226 432.257 364.129 429.501 364.14C426.746 364.151 424.638 357.239 424.603 348.698C424.568 340.156 426.716 333.186 429.375 333.175L429.499 333.187Z" fill="#410808" fill-opacity="0.2"/></g><defs><filter id="filter0_d_206_5" x="0.168377" y="0.181747" width="458.789" height="478.884" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_206_5" result="shape"/></filter></defs><text x="1.5" y="420"  font-size="25" fill="#DAA520" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgTwo = '</text></svg>';


    address payable public owner;

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint => string) public names;
    
    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);


    constructor(string memory _tld) payable ERC721("Donkey Name Service", "DNS")  {
        owner = payable(msg.sender);
        tld = _tld;
    }

 

    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10 ** 17;
        } else if (len == 4 ) {
            return 3* 10 ** 17;
        } else {
            return 1 * 10 ** 17;
        }
    }

    function register(string calldata name) public payable {
        if (domains[name] != address(0)) revert AlreadyRegistered();
        if (!valid(name)) revert InvalidName(name);
        require(domains[name] == address(0), "domains already registered");
        uint _price = price(name);
        require(msg.value >= _price, "Not enough MATIC");

        

        string memory _name = string(abi.encodePacked(name, ".", tld));
        string memory finalSVG = string(abi.encodePacked(svgOne, _name, svgTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                    _name,
                    '", "description": "A domain on the Donkey name service", "image": "data:image/svg+xml;base64, ',
                    Base64.encode(bytes(finalSVG)),
                    '", "length":"',
                    strLen,
                    '"}'
                    )
                )
            )
        );

        string memory finalTokeUri = string(abi.encodePacked("data:application/json;base64,", json));
        console.log("\n----------------------------------");
        console.log("Final tokenURI", finalTokeUri);
        console.log("-------------------------------------\n");


        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokeUri);
        domains[name] = msg.sender;
        names[newRecordId] = name;
        _tokenIds.increment();
    }

    function valid(string calldata name) public pure returns(bool) {
        return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        if (msg.sender != domains[name]) revert Unauthorized();
        records[name] = record;
        console.log("%s has set a record for %s", msg.sender, name);
    }
    
    function getRecord(string calldata name) public view returns (string memory) {
        if (msg.sender != domains[name]) revert Unauthorized();
        return records[name];
    }

    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIds.current());
        for (uint i = 0; i < _tokenIds.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }
        return allNames;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

 
   receive() external payable {}


    function withdraw() public onlyOwner {
        uint amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Mantic");
    }

    function getBalance() external view returns (uint) {

        return address(this).balance;

    }

}