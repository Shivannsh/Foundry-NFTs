// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {

    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public USER = address(1);
    string  public constant PUB= "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public {
        assertEq(basicNft.name() ,"Dogie");
    }

    // function canMintAndHaveBalance() public {
    //     vm.prank(USER);
    //     basicNft.mintNft(PUB);
    //     assert(basicNft.balanceOf(USER) == 1);
    //     assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUB)));
    // }
}