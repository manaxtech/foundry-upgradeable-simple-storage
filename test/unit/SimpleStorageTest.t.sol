// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage sStorage;

    function setUp() public {
        sStorage = new SimpleStorage();
    }

    function testFuzz_Store(uint256 randomNumber) public {
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        sStorage.store(expectedNumber);
        (uint256 recordedNumber, address sender) = sStorage.retrieve();
        assertEq(recordedNumber, expectedNumber);
        assertEq(sender, address(this));
    }

    function test_EuclidGCF() public view {
        uint256 expectedA = 64;
        uint256 expectedB = 44;

        (uint256 gcf, uint256 thzero) = sStorage.euclidGCF(expectedA, expectedB);
        assert(gcf == 4);
        assert(thzero == 0);
    }

    function test_AddPersonAndGetPerson() public {
        string memory name = "alice";
        uint256 expectedFavoriteNumber = 8;

        sStorage.addPerson(name, expectedFavoriteNumber);
        (string memory recordedName_1, uint256 recordedFavoriteNumber_1) = sStorage.getPerson(0);

        string memory recordedName_2 = sStorage.getPersonStruct(0).name;
        uint256 recordedFavoriteNumber_2 = sStorage.getPersonStruct(0).favoriteNumber;

        string memory recordedName_3 = sStorage.getPeopleStruct()[0].name;
        uint256 recordedFavoriteNumber_3 = sStorage.getPeopleStruct()[0].favoriteNumber;

        assert(keccak256(abi.encodePacked(recordedName_1)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_1 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_2)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_2 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_3)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_3 == expectedFavoriteNumber);
    }
}
