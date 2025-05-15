// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "src/SimpleStorage.sol";
import {AddFiveStorage} from "src/AddFiveStorage.sol";
import {DeployAddFiveStorage, DeploySimpleStorage} from "script/Deploy.s.sol";

contract AddFiveStorageTest is Test {
    SimpleStorage sStorage;
    AddFiveStorage afStorage;

    DeploySimpleStorage ssDeployer;
    DeployAddFiveStorage afDeployer;

    function setUp() public {
        afDeployer = new DeployAddFiveStorage();
        ssDeployer = new DeploySimpleStorage();

        afStorage = AddFiveStorage(afDeployer.run());
        // afStorage = AddFiveStorage(ssDeployer.run());
        // sStorage = SimpleStorage(afDeployer.run());
    }

    function test_typeCast() public {
        afStorage.store(5);
        (uint256 retrievedNumber,) = afStorage.retrieve();

        console.log("stored", retrievedNumber);

        // sStorage.store(5);
        // (uint256 retrievedNumber,) = sStorage.retrieve();
        // console.log("stored", retrievedNumber);
    }
}
