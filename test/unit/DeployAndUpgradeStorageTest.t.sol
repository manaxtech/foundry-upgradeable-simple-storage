// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {UUPSUSimpleStorage} from "../../src/UUPSUSimpleStorage.sol";
import {UUPSUAddFiveStorage} from "../../src/UUPSUAddFiveStorage.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeStorageTest is Test {
    ERC1967Proxy proxy;

    UUPSUSimpleStorage upgradeableSimpleStorage;
    UUPSUAddFiveStorage upgradeableAddFiveStorage;

    UUPSUSimpleStorage uSimpleStorageProxy;
    UUPSUAddFiveStorage uAddFiveStorageProxy;

    function setUp() public {
        upgradeableSimpleStorage = new UUPSUSimpleStorage();

        proxy = new ERC1967Proxy(address(upgradeableSimpleStorage), hex"");

        uSimpleStorageProxy = UUPSUSimpleStorage(address(proxy));
        uSimpleStorageProxy.initialize();

        uAddFiveStorageProxy = UUPSUAddFiveStorage(address(proxy));
    }

    function test_SimpleStorageProxy() public {
        uint256 expectedNumber = 30;
        (uint256 initialVar,) = uSimpleStorageProxy.retrieve();

        uSimpleStorageProxy.store(expectedNumber);
        (uint256 recordedNumber, address sender) = uSimpleStorageProxy.retrieve();
        console.log("Retrive", initialVar);

        assert(recordedNumber == expectedNumber);
        assert(sender == address(this));
        assert(uSimpleStorageProxy.owner() == address(this));
        assert(initialVar == 3);
    }

    function test_UpgradeToAddFiveStorage() public {
        upgradeableAddFiveStorage = new UUPSUAddFiveStorage();
        uSimpleStorageProxy.upgradeToAndCall(address(upgradeableAddFiveStorage), "");
        uAddFiveStorageProxy.initialize();
        (uint256 initialVar,) = uAddFiveStorageProxy.retrieve();

        uint256 expectedNumber = 30;
        uAddFiveStorageProxy.store(expectedNumber);
        (uint256 recordedNumber, address sender) = uAddFiveStorageProxy.retrieve();
        assert(recordedNumber == expectedNumber + 5);
        assert(sender == address(this));
        assert(uSimpleStorageProxy.owner() == address(this));
        assert(initialVar == 5 + 5);
    }
}