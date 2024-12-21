
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MusicCreationGame
 * @dev A smart contract for music creation games with tokenized compositions as NFTs.
 */
contract MusicCreationGame is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => address) public composers;

    event CompositionCreated(uint256 tokenId, address composer, string tokenURI);

    /**
     * @dev Constructor to initialize the ERC721 and Ownable contracts.
     */
    constructor() ERC721("MusicCreationGame", "MCG") Ownable(msg.sender) {}

    /**
     * @dev Mint a new music composition as an NFT.
     * @param tokenURI The metadata URI of the music composition.
     */
    function mintComposition(string memory tokenURI) public {
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(msg.sender, tokenId); // Mint NFT
        _setTokenURI(tokenId, tokenURI); // Set metadata URI
        composers[tokenId] = msg.sender; // Record composer

        emit CompositionCreated(tokenId, msg.sender, tokenURI);
    }

    /**
     * @dev Fetch the composer of a specific token.
     * @param tokenId The ID of the token.
     * @return The address of the composer.
     */
    function getComposer(uint256 tokenId) public view returns (address) {
        return composers[tokenId];
    }

    /**
     * @dev Burn a composition NFT owned by the caller.
     * @param tokenId The ID of the token to burn.
     */
    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        _burn(tokenId);
    }
}