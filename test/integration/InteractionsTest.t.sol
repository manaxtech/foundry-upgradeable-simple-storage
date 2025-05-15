// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
// import {SimpleStorage} from "src/SimpleStorage.sol";
import {DeploySimpleStorage} from "script/Deploy.s.sol";
import {
    StoreSimpleStorage,
    RetrieveSimpleStorage,
    AddPersonSimpleStorage,
    GetPersonSimpleStorage,
    GetPersonStructSimpleStorage,
    GetPeopleStructSimpleStorage,
    EuclidGCFSimpleStorage
} from "script/Interactions.s.sol";

contract InteractionsTest is Test {
    address sStorage;
    DeploySimpleStorage deployer;

    StoreSimpleStorage store;
    RetrieveSimpleStorage retrieve;
    AddPersonSimpleStorage addPerson;
    GetPersonSimpleStorage getPerson;
    GetPersonStructSimpleStorage getPersonStruct;
    GetPeopleStructSimpleStorage getPeopleStruct;
    EuclidGCFSimpleStorage euclidGCF;

    function setUp() public {
        deployer = new DeploySimpleStorage();
        sStorage = deployer.run();

        store = new StoreSimpleStorage();
        retrieve = new RetrieveSimpleStorage();
        addPerson = new AddPersonSimpleStorage();
        getPerson = new GetPersonSimpleStorage();
        getPersonStruct = new GetPersonStructSimpleStorage();
        getPeopleStruct = new GetPeopleStructSimpleStorage();
        euclidGCF = new EuclidGCFSimpleStorage();
    }

    function test_InteractionStoreAndRetrieve() public {
        uint256 expectedNumber = 3;

        store._storeSimpleStorage(sStorage, expectedNumber);
        (uint256 recordedNumber, address sender) = retrieve._retrieveSimpleStorage(sStorage);

        assert(recordedNumber == expectedNumber);
        assert(sender == msg.sender);
    }

    function test_InteractionsAddPersonAndGetPerson() public {
        string memory name = "alice";
        uint256 expectedFavoriteNumber = 8;

        addPerson._addPersonSimpleStorage(sStorage, name, expectedFavoriteNumber);
        (string memory recordedName_1, uint256 recordedFavoriteNumber_1) = getPerson._getPersonSimpleStorage(sStorage);

        string memory recordedName_2 = getPersonStruct._getPersonStructSimpleStorage(sStorage).name;
        uint256 recordedFavoriteNumber_2 = getPersonStruct._getPersonStructSimpleStorage(sStorage).favoriteNumber;

        string memory recordedName_3 = getPeopleStruct._getPeopleStructSimpleStorage(sStorage)[0].name;
        uint256 recordedFavoriteNumber_3 = getPeopleStruct._getPeopleStructSimpleStorage(sStorage)[0].favoriteNumber;

        assert(keccak256(abi.encodePacked(recordedName_1)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_1 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_2)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_2 == expectedFavoriteNumber);

        assert(keccak256(abi.encodePacked(recordedName_3)) == keccak256(abi.encodePacked(name)));
        assert(recordedFavoriteNumber_3 == expectedFavoriteNumber);
    }

    function test_InteractionEuclidGCF() public {
        uint256 firstNumber = 66;
        uint256 secondNumber = 55;

        (uint256 gcf, uint256 thzero) = euclidGCF._euclidGCFSimpleStorage(sStorage, firstNumber, secondNumber);

        assert(gcf == 11);
        assert(thzero == 0);
    }
}
