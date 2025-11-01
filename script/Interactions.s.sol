// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Foundry helper that provides `vm` cheatcodes (startBroadcast, env helpers, etc.)
import {Script} from "forge-std/Script.sol";

// DevOps helper library shipped under `lib/foundry-devops` in this repo.
// Provides helpers for reading the `broadcast` artifacts to locate most
// recently deployed contract addresses (used in this script).
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

// The contract we will interact with (deployed previously by a deploy script).
import {BasicNft} from "../src/BasicNft.sol";

/**
 * @title MintBasicNft
 * @notice Small Foundry Script that mints a BasicNft using the most recent
 *         deployment artifact found in `./broadcast` for the current chain.
 * @dev This script uses `DevOpsTools.get_most_recent_deployment` to discover
 *      the deployed address, then performs a transaction using
 *      `vm.startBroadcast()` / `vm.stopBroadcast()` so the call is sent from
 *      the private key provided when running `forge script --broadcast`.
 */
contract MintBasicNft is Script {
    // Example metadata URI used for minting. Replace with your own if needed.
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    /**
     * @notice Entry point called by `forge script`.
     * @dev This function locates the most recent `BasicNft` deployment for the
     *      current chain and calls `mintNftOnContract` to perform the mint.
     *      When run without `--broadcast` Foundry executes this as a dry-run
     *      (no on-chain transactions). When run with `--broadcast` and a
     *      private key, the mint will be sent as a real transaction.
     */
    function run() external {
        // Look up the latest deployed BasicNft address from broadcast artifacts.
        // Mint a token on the found contract address.
        // Prefer an explicit address provided through an environment variable
        // (useful for broadcast runs where reading local `./broadcast` artifacts
        // via vm.readDir/readFile is not permitted). If the env var is not set,
        // fall back to parsing `./broadcast` artifacts (works during dry-runs).
        address mostRecentDeployedContract = vm.envAddress("BASIC_NFT_ADDRESS");

        if (mostRecentDeployedContract == address(0)) {
            // Only attempt to read local broadcast artifacts when no env var is set.
            mostRecentDeployedContract = DevOpsTools.get_most_recent_deployment(
                    "BasicNft",
                    block.chainid
                );
        }

        // Mint a token on the found contract address.
        mintNftOnContract(mostRecentDeployedContract);
    }

    /**
     * @notice Mint a BasicNft on a deployed contract address.
     * @param contractAddress The address of a deployed `BasicNft` contract.
     * @dev Calls between `vm.startBroadcast()` and `vm.stopBroadcast()` are
     *      actually broadcast when you run the script with `--broadcast` and
     *      supply a private key. Without `--broadcast` this block executes in
     *      a local simulated environment (no on-chain effects).
     */
    function mintNftOnContract(address contractAddress) public {
        // Begin broadcasting transactions (real when using --broadcast)
        vm.startBroadcast();

        // Cast the raw address to the BasicNft interface and call mintNft.
        BasicNft basicNft = BasicNft(contractAddress);
        basicNft.mintNft(PUG);

        // Stop broadcasting — subsequent calls (if any) will not be sent.
        vm.stopBroadcast();
    }
}
