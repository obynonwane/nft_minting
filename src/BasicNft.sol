// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title BasicNft
 * @author ojohnson
 * @notice Minimal ERC721 NFT contract used for tutorial and tests.
 * @dev This header includes SPDX license, solidity pragma, and NatSpec comments.
 *      Replace or extend the contract below with actual implementation.
 */

contract BasicNft is ERC721 {
    // add token counter to track how many was minted or minted so far
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    // represent the entire collection of Doggie
    // each Doggie have its own tokenId
    constructor() ERC721("Dogie", "DOG") {
        // set s_token counter to zero
        // initialize token counter to zero
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        // mint the NFT to msg.sender with current token counter as tokenId
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        // increment the token counter
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public pure override returns (string memory) {
        return "https://dxrg-02.nyc3.cdn.digitaloceanspaces.com/metadata/1684";
    }
}
