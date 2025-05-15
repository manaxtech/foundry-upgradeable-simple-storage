// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Target, ProxyT} from "../src/DelegateUpgradeable.sol";
import {AddFiveStorage} from "../src/AddFiveStorage.sol";
import {SmallProxy} from "../src/SmallProxy.sol";

contract StoreSimpleStorage is Script {
    uint256 constant FAVORITE_NUMBER = 50;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        _storeSimpleStorage(mostRecentlyDeployed, FAVORITE_NUMBER);
    }

    function _storeSimpleStorage(address contractAddress, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        SimpleStorage(contractAddress).store(_favoriteNumber);
        vm.stopBroadcast();
    }
}

contract EuclidGCFSimpleStorage is Script {
    uint256 constant FIRST = 64;
    uint256 constant SECOND = 56;

    function run() external returns (uint256 gcf, uint256 thzero) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        return _euclidGCFSimpleStorage(mostRecentlyDeployed, FIRST, SECOND);
    }

    function _euclidGCFSimpleStorage(address contractAddress, uint256 a, uint256 b)
        public
        returns (uint256 gcf, uint256 thzero)
    {
        vm.startBroadcast();
        (gcf, thzero) = SimpleStorage(contractAddress).euclidGCF(a, b);
        vm.stopBroadcast();
    }
}

contract AddPersonSimpleStorage is Script {
    uint256 constant LENGTH = 3;

    function run() external {
        string[] memory names = new string[](LENGTH);
        uint256[] memory favoriteNumbers = new uint256[](LENGTH);
        names[0] = "alice";
        names[1] = "bob";
        names[2] = "charlie";

        favoriteNumbers[0] = 3;
        favoriteNumbers[1] = 4;
        favoriteNumbers[2] = 8;
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        for (uint8 i = 0; i < LENGTH; i++) {
            _addPersonSimpleStorage(mostRecentlyDeployed, names[i], favoriteNumbers[i]);
        }
    }

    function _addPersonSimpleStorage(address contractAddress, string memory _name, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        SimpleStorage(contractAddress).addPerson(_name, _favoriteNumber);
        vm.stopBroadcast();
    }
}

contract RetrieveSimpleStorage is Script {
    function run() external returns (uint256 favoriteNumber, address sender) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        return _retrieveSimpleStorage(mostRecentlyDeployed);
    }

    function _retrieveSimpleStorage(address contractAddress) public returns (uint256 favoriteNumber, address sender) {
        vm.startBroadcast();
        (favoriteNumber, sender) = SimpleStorage(contractAddress).retrieve();
        vm.stopBroadcast();
    }
}

contract GetPersonSimpleStorage is Script {
    uint256 constant INDEX = 0;

    function run() external returns (string memory name, uint256 favoriteNumber) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        return _getPersonSimpleStorage(mostRecentlyDeployed);
    }

    function _getPersonSimpleStorage(address contractAddress)
        public
        returns (string memory name, uint256 favoriteNumber)
    {
        vm.startBroadcast();
        (name, favoriteNumber) = SimpleStorage(contractAddress).getPerson(INDEX);
        vm.stopBroadcast();
    }
}

contract GetPersonStructSimpleStorage is Script {
    uint256 constant INDEX = 0;

    function run() external returns (SimpleStorage.Person memory person) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        person = _getPersonStructSimpleStorage(mostRecentlyDeployed);
    }

    function _getPersonStructSimpleStorage(address contractAddress)
        public
        returns (SimpleStorage.Person memory person)
    {
        vm.startBroadcast();
        person = SimpleStorage(contractAddress).getPersonStruct(INDEX);
        vm.stopBroadcast();
    }
}

contract GetPeopleStructSimpleStorage is Script {
    function run() external returns (SimpleStorage.Person[] memory person) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleStorage", block.chainid);
        person = _getPeopleStructSimpleStorage(mostRecentlyDeployed);
    }

    function _getPeopleStructSimpleStorage(address contractAddress)
        public
        returns (SimpleStorage.Person[] memory person)
    {
        vm.startBroadcast();
        person = SimpleStorage(contractAddress).getPeopleStruct();
        vm.stopBroadcast();
    }
}

/* ADDFIVESTORAGE */

contract StoreAddFiveStorage is  Script {
    uint256 constant FAVORITE_NUMBER = 50;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("AddFiveStorage", block.chainid);
        _storeAddFiveStorage(mostRecentlyDeployed, FAVORITE_NUMBER);
    }

    function _storeAddFiveStorage(address contractAddress, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        AddFiveStorage(contractAddress).store(_favoriteNumber);
        vm.stopBroadcast();
    }
}

contract RetrieveAddFiveStorage is Script {
    function run() external returns (uint256 favoriteNumber, address sender) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("AddFiveStorage", block.chainid);
        return _retrieveAddFiveStorage(mostRecentlyDeployed);
    }

    function _retrieveAddFiveStorage(address contractAddress) public returns (uint256 favoriteNumber, address sender) {
        vm.startBroadcast();
        (favoriteNumber, sender) = AddFiveStorage(contractAddress).retrieve();
        vm.stopBroadcast();
    }
}

/******************************************** DELEGATE ********************************************/
contract SetProxyT is Script {
    uint256 public constant VALUE = 45;
    uint256 public constant SEND_MONEY = 0.01 ether;

    function run() external {
        address mostRecentlyDeployedProxyT = DevOpsTools.get_most_recent_deployment("ProxyT", block.chainid);
        address mostRecentlyDeployedTarget = DevOpsTools.get_most_recent_deployment("Target", block.chainid);
        _setProxyT(mostRecentlyDeployedProxyT, mostRecentlyDeployedTarget, VALUE);
    }

    function _setProxyT(address proxyTContractAddress, address targetContractAddress, uint256 _value) public {
        vm.startBroadcast();
        ProxyT(proxyTContractAddress).set{value: SEND_MONEY}(targetContractAddress, _value);
        vm.stopBroadcast();
    }
}

contract CallAnyFunctionProxyT is Script {
    uint256 public constant SEND_MONEY = 0.01 ether;

    function run() external {
        address mostRecentlyDeployedProxyT = DevOpsTools.get_most_recent_deployment("ProxyT", block.chainid);
        address mostRecentlyDeployedTarget = DevOpsTools.get_most_recent_deployment("Target", block.chainid);
        // bytes memory DATA = ProxyT(mostRecentlyDeployedProxyT).someData();
        // @audit there is some error passing the variable in here b/c hex"55..." and "0x55.." are d/t in bytes in remix and here(in remix it only work as an input)
        // bytes memory DATA = "0x55241077000000000000000000000000000000000000000000000000000000000000002d";
        bytes memory DATA =
            hex"55241077000000000000000000000000000000000000000000000000000000000000002d00000000000000000000000000000000000000000000000000000000";

        _callAnyFunctionProxyT(mostRecentlyDeployedProxyT, mostRecentlyDeployedTarget, DATA);
    }

    function _callAnyFunctionProxyT(address proxyTContractAddress, address targetContractAddress, bytes memory _data)
        public
    {
        vm.startBroadcast();
        ProxyT(proxyTContractAddress).callAnyFunction{value: SEND_MONEY}(targetContractAddress, _data);
        vm.stopBroadcast();
    }
}

contract ValueSenderMoney1Money2SomeDataProxyT is Script {
    function run()
        public
        returns (uint256 value, address sender, uint256 money1, uint256 money2, bytes memory someData)
    {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ProxyT", block.chainid);
        return _valueSenderMoney1Money2ProxyT(mostRecentlyDeployed);
    }

    function _valueSenderMoney1Money2ProxyT(address contractAddress)
        public
        returns (uint256 value, address sender, uint256 money1, uint256 money2, bytes memory someData)
    {
        vm.startBroadcast();
        value = ProxyT(contractAddress).value();
        sender = ProxyT(contractAddress).sender();
        money1 = ProxyT(contractAddress).money1();
        money2 = ProxyT(contractAddress).money2();
        someData = ProxyT(contractAddress).someData();
        vm.stopBroadcast();
    }
}

/******************************************** Small Proxy ********************************************/

contract SetImplementationSmallProxy is Script {
    string public contractName = "SimpleStorage";

    function run() external {
        address payable mostRecentlyDeployedSmallProxy = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));
        address mostRecentlyDeployedImplementation = DevOpsTools.get_most_recent_deployment(contractName, block.chainid);

        _setImplementationSmallProxy(mostRecentlyDeployedSmallProxy, mostRecentlyDeployedImplementation);
    }
    function _setImplementationSmallProxy(address payable smallProxy, address implementedAddress) public {
        // or to make it simple make smallProxy inside typecasting payable but for consistency I have kept doing this payable everywhere
        vm.startBroadcast();
        SmallProxy(smallProxy).setImplementation(implementedAddress);
        vm.stopBroadcast();
    }
}

contract StoreSimpleStorageSmallProxy is Script {
    uint256 constant FAVORITE_NUMBER = 50;

    function run() external {
        address payable mostRecentlyDeployed = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));

        _storeSimpleStoageSmallProxy(mostRecentlyDeployed, FAVORITE_NUMBER);
    }

    function _storeSimpleStoageSmallProxy(address smallProxy, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        SimpleStorage(smallProxy).store(_favoriteNumber);
        vm.stopBroadcast();
    }
}

contract StoreAddFiveStorageSmallProxy is Script {
    uint256 constant FAVORITE_NUMBER = 50;

    function run() external {
        address payable mostRecentlyDeployed = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));

        _storeSimpleStoageSmallProxy(mostRecentlyDeployed, FAVORITE_NUMBER);
    }

    function _storeSimpleStoageSmallProxy(address smallProxy, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        AddFiveStorage(smallProxy).store(_favoriteNumber);
        vm.stopBroadcast();
    }
}

contract RetrieveSimpleStorageSmallProxy is Script {
    function run() external returns (uint256 favoriteNumber, address sender) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid);
        return _retrieveSimpleStorageSmallProxy(mostRecentlyDeployed);
    }

    function _retrieveSimpleStorageSmallProxy(address smallProxy) public returns (uint256 favoriteNumber, address sender) {
        vm.startBroadcast();
        (favoriteNumber, sender) = SimpleStorage(smallProxy).retrieve();
        vm.stopBroadcast();
    }
}

contract RetrieveAddFiveStorageSmallProxy is Script {
    function run() external returns (uint256 favoriteNumber, address sender) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid);
        return _retrieveSimpleStorageSmallProxy(mostRecentlyDeployed);
    }

    function _retrieveSimpleStorageSmallProxy(address smallProxy) public returns (uint256 favoriteNumber, address sender) {
        vm.startBroadcast();
        (favoriteNumber, sender) = SimpleStorage(smallProxy).retrieve();
        vm.stopBroadcast();
    }
}

// Instead of typecasting to retrieve we could use assembly to read stuff
// In future use assembly if there is a way

contract ReadStorageSlotZeroSmallProxy is Script {
    function run() public returns (uint256 valueAtStorageSlot0) {
        address payable mostRecentlyDeployed = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));
        valueAtStorageSlot0 = _readStorageSlotZeroSmallProxy(mostRecentlyDeployed);
    }

    function _readStorageSlotZeroSmallProxy(address payable smallProxy) public returns (uint256 valueAtStorageSlot0) {
        vm.startBroadcast();
        valueAtStorageSlot0 = SmallProxy(smallProxy).readStorageSlot0();
        vm.stopBroadcast();
    }
}

contract ReadStorageSlotOneSmallProxy is Script {
    function run() public returns (uint256 valueAtStorageSlot1) {
        address payable mostRecentlyDeployed = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));
        valueAtStorageSlot1 = _readStorageSlotOneSmallProxy(mostRecentlyDeployed);
    }
    
    function _readStorageSlotOneSmallProxy(address payable smallProxy) public returns (uint256 valueAtStorageSlot1) {
        vm.startBroadcast();
        valueAtStorageSlot1 = SmallProxy(smallProxy).readStorageSlot1();
        vm.stopBroadcast();
    }
}

contract ReadStorageSlotTwoSmallProxy is Script {
    function run() public returns (bytes32 valueAtStorageSlot2) {
        address payable mostRecentlyDeployed = payable(DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid));
        valueAtStorageSlot2 = _readStorageSlotTwoSmallProxy(mostRecentlyDeployed);
    }
    
    function _readStorageSlotTwoSmallProxy(address payable smallProxy) public returns (bytes32 valueAtStorageSlot2) {
        vm.startBroadcast();
        valueAtStorageSlot2 = SmallProxy(smallProxy).readStorageSlot2();
        vm.stopBroadcast();
    }
}

contract AddPersonSimpleStorageSmallProxy is Script {
    uint256 constant LENGTH = 3;

    function run() external {
        string[] memory names = new string[](LENGTH);
        uint256[] memory favoriteNumbers = new uint256[](LENGTH);
        names[0] = "alice";
        names[1] = "bob";
        names[2] = "charlie";

        favoriteNumbers[0] = 3;
        favoriteNumbers[1] = 4;
        favoriteNumbers[2] = 8;
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SmallProxy", block.chainid);
        for (uint8 i = 0; i < LENGTH; i++) {
            _addPersonSimpleStorageSmallProxy(mostRecentlyDeployed, names[i], favoriteNumbers[i]);
        }
    }

    function _addPersonSimpleStorageSmallProxy(address smallProxy, string memory _name, uint256 _favoriteNumber) public {
        vm.startBroadcast();
        SimpleStorage(smallProxy).addPerson(_name, _favoriteNumber);
        vm.stopBroadcast();
    }
}