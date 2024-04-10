// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@OpenZeppelin/openzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum MOOD {
        HAPPY,
        SAD
    }

    mapping(uint256 => MOOD) private s_tokenIdToMood;

    constructor(string memory happySvgImageUri, string memory sadSvgImageUri) ERC721("Moodie", "MOOD") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    function mintNft(string memory tokenUri) public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal view override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY) {
            s_tokenIdToMood[tokenId] = MOOD.SAD;
        } else {
            s_tokenIdToMood[tokenId] = MOOD.HAPPY;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
