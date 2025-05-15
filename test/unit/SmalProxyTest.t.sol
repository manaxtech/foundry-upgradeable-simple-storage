// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {AddFiveStorage} from "../../src/AddFiveStorage.sol";
import {SmallProxy} from "../../src/SmallProxy.sol";

contract SmallProxyTest is Test {
    SimpleStorage sStorage;
    AddFiveStorage afStorage;

    SimpleStorage sStorageProxy;
    AddFiveStorage afStorageProxy;

    SmallProxy sProxy;

    function setUp() public {
        sProxy = new SmallProxy();
        sStorage = new SimpleStorage();
        afStorage = new AddFiveStorage();

        sProxy.setImplementation(address(sStorage));
        sStorageProxy = SimpleStorage(address(sProxy));
    }

    function testFuzz_SmallProxyStore(uint256 randomNumber) public {
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        sStorageProxy.store(expectedNumber);
        (uint256 recordedNumber, address sender) = sStorageProxy.retrieve();
        assertEq(recordedNumber, expectedNumber);
        assertEq(sender, address(this));
    }

    function test_SmallProxyEuclidGCF() public view {
        uint256 expectedA = 64;
        uint256 expectedB = 44;

        (uint256 gcf, uint256 thzero) = sStorageProxy.euclidGCF(expectedA, expectedB);
        assert(gcf == 4);
        assert(thzero == 0);
    }

    function test_SmallProxyAddPersonAndGetPerson() public {
        string memory name = "alice";
        uint256 expectedFavoriteNumber = 8;

        sStorageProxy.addPerson(name, expectedFavoriteNumber);
        (string memory recordedName_1, uint256 recordedFavoriteNumber_1) = sStorageProxy.getPerson(0);

        string memory recordedName_2 = sStorageProxy.getPersonStruct(0).name;
        uint256 recordedFavoriteNumber_2 = sStorageProxy.getPersonStruct(0).favoriteNumber;

        string memory recordedName_3 = sStorageProxy.getPeopleStruct()[0].name;
        uint256 recordedFavoriteNumber_3 = sStorageProxy.getPeopleStruct()[0].favoriteNumber;

        assert(keccak256(abi.encodePacked(recordedName_1)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_1 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_2)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_2 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_3)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_3 == expectedFavoriteNumber);
    }

    function testFuzz_UpgradeToAddFiveStorageAndCheckProxystorage(uint256 randomNumber)  public {
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        sStorageProxy.store(expectedNumber);

        sProxy.setImplementation(address(afStorage));
        afStorageProxy = AddFiveStorage(address(sProxy));

        (uint256 recordedNumber, address sender) = afStorageProxy.retrieve();
        assertEq(recordedNumber, expectedNumber);
        assertEq(sender, address(this));
    }

    function testFuzz_UpgradeToAddFiveStorageAndCallAlteredFunction() public {
        uint256 randomNumber = 23;
        uint256 expectedNumber = bound(randomNumber, 0, type(uint8).max);
        sStorageProxy.store(expectedNumber);

        sProxy.setImplementation(address(afStorage));
        afStorageProxy = AddFiveStorage(address(sProxy));

        (uint256 recordedNumber1, address sender1) = afStorageProxy.retrieve();

        afStorageProxy.store(expectedNumber);
        (uint256 recordedNumber2, address sender2) = afStorageProxy.retrieve();

        // error here correct the way you encode b/c store(uint256) works but not addPerson(string, uint256)
        // (bool success, ) = address(sProxy).call(abi.encodeWithSignature("addPerson(string, uint256)", "alice", 43));
        // console.log("success", success);

        uint256 recordedNumber3 = sProxy.readStorageSlot0();
        uint256 arrayLength = sProxy.readStorageSlot1();

        assertEq(recordedNumber1, expectedNumber);
        assertEq(recordedNumber2, expectedNumber + 5);
        assertEq(recordedNumber3, recordedNumber2);
        assertEq(arrayLength, 0);
        assertEq(sender1, address(this));
        assertEq(sender2, address(this));
        // assert(success);
    }
}
