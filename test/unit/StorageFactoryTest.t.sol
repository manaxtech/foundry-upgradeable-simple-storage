// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {StorageFactory} from "../../src/StorageFactory.sol";

contract StorageFactoryTest is Test {
    StorageFactory factory;
    address simpleStorageAddress;
    uint256 public constant CONTRACT_INDEX = 0;

    function setUp() public {
        // sStorage = new SimpleStorage();
        factory = new StorageFactory();
        factory.createSimpleStorageContract();
        simpleStorageAddress = address(factory.sStorageContracts(CONTRACT_INDEX));
    }

    function testFuzz_StoreUsingIndex(uint256 randomNumber) public {
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        factory.sf_Store(CONTRACT_INDEX, expectedNumber);
        (uint256 recordedNumber, address sender) = factory.sf_Retrive(CONTRACT_INDEX);
        assertEq(recordedNumber, expectedNumber);
        assertEq(sender, address(factory));
    }

    function testFuzz_StoreUsingInterface(uint256 randomNumber) public {
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        factory.sfi_Store(simpleStorageAddress, expectedNumber);
        (uint256 recordedNumber, address sender) = factory.sfi_Retrive(simpleStorageAddress);
        assertEq(recordedNumber, expectedNumber);
        assertEq(sender, address(factory));
    }

    function test_EuclidGCFUsingIndex() public view {
        uint256 expectedA = 64;
        uint256 expectedB = 44;

        (uint256 gcf, uint256 thzero) = factory.sf_EuclidGCF(CONTRACT_INDEX, expectedA, expectedB);
        assert(gcf == 4);
        assert(thzero == 0);
    }

    function test_EuclidGCFUsingInterface() public view {
        uint256 expectedA = 64;
        uint256 expectedB = 44;

        (uint256 gcf, uint256 thzero) = factory.sfi_EuclidGCF(simpleStorageAddress, expectedA, expectedB);
        assert(gcf == 4);
        assert(thzero == 0);
    }

    function test_AddPersonAndGetPersonUsingIndex() public {
        string memory name = "alice";
        uint256 expectedFavoriteNumber = 8;

        factory.sf_AddPerson(CONTRACT_INDEX, name, expectedFavoriteNumber);
        (string memory recordedName_1, uint256 recordedFavoriteNumber_1) = factory.sf_GetPerson(CONTRACT_INDEX, 0);

        string memory recordedName_2 = factory.sf_GetPersonStruct(CONTRACT_INDEX, 0).name;
        uint256 recordedFavoriteNumber_2 = factory.sf_GetPersonStruct(CONTRACT_INDEX, 0).favoriteNumber;

        string memory recordedName_3 = factory.sf_GetPeopleStruct(CONTRACT_INDEX)[0].name;
        uint256 recordedFavoriteNumber_3 = factory.sf_GetPeopleStruct(CONTRACT_INDEX)[0].favoriteNumber;

        assert(keccak256(abi.encodePacked(recordedName_1)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_1 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_2)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_2 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_3)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_3 == expectedFavoriteNumber);
    }

    function test_AddPersonAndGetPersonUsingInterface() public {
        string memory name = "alice";
        uint256 expectedFavoriteNumber = 8;

        factory.sfi_AddPerson(simpleStorageAddress, name, expectedFavoriteNumber);
        (string memory recordedName_1, uint256 recordedFavoriteNumber_1) = factory.sfi_GetPerson(simpleStorageAddress, 0);

        string memory recordedName_2 = factory.sfi_GetPersonStruct(simpleStorageAddress, 0).name;
        uint256 recordedFavoriteNumber_2 = factory.sfi_GetPersonStruct(simpleStorageAddress, 0).favoriteNumber;

        string memory recordedName_3 = factory.sfi_GetPeopleStruct(simpleStorageAddress)[0].name;
        uint256 recordedFavoriteNumber_3 = factory.sfi_GetPeopleStruct(simpleStorageAddress)[0].favoriteNumber;

        assert(keccak256(abi.encodePacked(recordedName_1)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_1 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_2)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_2 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_3)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_3 == expectedFavoriteNumber);
    }
}
