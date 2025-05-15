// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";
import {AddFiveStorage} from "../src/AddFiveStorage.sol";
import {StorageFactory} from "../src/StorageFactory.sol";
import {Target, ProxyT} from "../src/DelegateUpgradeable.sol";
import {SmallProxy} from "../src/SmallProxy.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UUPSUSimpleStorage} from "../src/UUPSUSimpleStorage.sol";
import {UUPSUAddFiveStorage} from "../src/UUPSUAddFiveStorage.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (address) {
        return deploySimpleStorage();
    }

    function deploySimpleStorage() private returns (address) {
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        return address(simpleStorage);
    }
}

contract DeployAddFiveStorage is Script {
    function run() external returns (address) {
        return deployAddFiveStorage();
    }

    function deployAddFiveStorage() private returns (address) {
        vm.startBroadcast();
        AddFiveStorage addFiveStorage = new AddFiveStorage();
        vm.stopBroadcast();
        return address(addFiveStorage);
    }
}

contract DeployStorageFactory is Script {
    function run() external returns (address) {
        return deployStorageFactory();
    }

    function deployStorageFactory() private returns (address) {
        vm.startBroadcast();
        StorageFactory storageFactory = new StorageFactory();
        vm.stopBroadcast();
        return address(storageFactory);
    }
}

contract DeployTarget is Script {
    function run() external returns (address) {
        return deployTarget();
    }

    function deployTarget() private returns (address) {
        vm.startBroadcast();
        Target target = new Target();
        vm.stopBroadcast();
        return address(target);
    }
}

contract DeployProxyT is Script {
    function run() external returns (address) {
        return deployProxyT();
    }

    function deployProxyT() private returns (address) {
        vm.startBroadcast();
        ProxyT proxy = new ProxyT();
        vm.stopBroadcast();
        return address(proxy);
    }
}

contract DeploySmallProxy is Script {
    function run() external returns (address) {
        return deploySmallProxy();
    }

    function deploySmallProxy() private returns (address) {
        vm.startBroadcast();
        SmallProxy smallProxy = new SmallProxy();
        vm.stopBroadcast();
        return address(smallProxy);
    }
}

contract DeploySimpleUpgradeableTemplate is Script {
    function run() external returns (address) {
        return deploySimpleUpgradeableTemplate();
    }

    function deploySimpleUpgradeableTemplate() private returns (address) {
        vm.startBroadcast();
        UUPSUSimpleStorage upgradeableStorage = new UUPSUSimpleStorage();
        vm.stopBroadcast();
        return address(upgradeableStorage);
    }
}

contract DeployAddFiveUpgradeableTemplate is Script {
    function run() external returns (address) {
        return deployAddFiveUpgradeableTemplate();
    }

    function deployAddFiveUpgradeableTemplate() private returns (address) {
        vm.startBroadcast();
        UUPSUAddFiveStorage upgradeableStorage = new UUPSUAddFiveStorage();
        vm.stopBroadcast();
        return address(upgradeableStorage);
    }
}

contract DeployUpgradeableStorage is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedUpgradeableStorage = DevOpsTools.get_most_recent_deployment("UUPSUSimpleStorage", block.chainid);
        return deployUpgradeableStorage(mostRecentlyDeployedUpgradeableStorage);
    }

    function deployUpgradeableStorage(address implementation) private returns (address) {
        vm.startBroadcast();
        ERC1967Proxy proxy = new ERC1967Proxy(implementation, "");
        vm.stopBroadcast();
        return address(proxy);
    }
}

contract UpgradeUpgradeableStorage is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        address mostRecentlyDeployedUpgradeableStorage = DevOpsTools.get_most_recent_deployment("UUPSUAddFiveStorage", block.chainid);
        return upgradeUpgradeableStorage(mostRecentlyDeployedProxy, mostRecentlyDeployedUpgradeableStorage);
    }

    function upgradeUpgradeableStorage(address proxy, address newImplementation) private returns (address) {
        vm.startBroadcast();
        UUPSUSimpleStorage(proxy).upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();

        return proxy;
    }
}