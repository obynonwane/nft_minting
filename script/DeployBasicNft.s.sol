// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import BasicNft contract
import {BasicNft} from "../src/BasicNft.sol";
// import Script from forge-std
import {Script} from "forge-std/Script.sol";

/**
 * @title DeployBasicNft
 * @author ojohnson
 * @notice Script to deploy the BasicNft contract.
 * @dev This script uses Foundry's Script functionality to deploy the BasicNft contract.
 */
contract DeployBasicNft is Script {
    function run() external returns (BasicNft) {
        // start broadcasting transactions
        vm.startBroadcast();
        // deploy the BasicNft contract
        BasicNft basicNft = new BasicNft();

        vm.stopBroadcast();

        return basicNft;
    }
}
