// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {SimpleStorage} from "./SimpleStorage.sol";
import {ISimpleStorage} from "./ISimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public sStorageContracts;

    function createSimpleStorageContract() public {
        sStorageContracts.push(new SimpleStorage());
    }

    // to interact with Another contract we need Application Binary Interface(ABI) and address

    /* Interaction using contract at an index */
    function sf_Store(uint256 contractIndex, uint256 favoriteNumber) public {
        sStorageContracts[contractIndex].store(favoriteNumber);
    }

    function sf_AddPerson(uint256 contractIndex, string calldata name, uint256 favoriteNumber) public {
        sStorageContracts[contractIndex].addPerson(name, favoriteNumber);
    }

    function sf_EuclidGCF(uint256 contractIndex, uint256 a, uint256 b)
        public
        view
        returns (uint256 gcf, uint256 thzero)
    {
        return sStorageContracts[contractIndex].euclidGCF(a, b);
    }

    function sf_Retrive(uint256 contractIndex) external view returns (uint256 favoriteNumber, address sender) {
        return sStorageContracts[contractIndex].retrieve();
    }

    function sf_GetPerson(uint256 contractIndex, uint256 personIndex) external view returns (string memory, uint256) {
        return sStorageContracts[contractIndex].getPerson(personIndex);
    }

    function sf_GetPersonStruct(uint256 contractIndex, uint256 personIndex)
        external
        view
        returns (SimpleStorage.Person memory)
    {
        return sStorageContracts[contractIndex].getPersonStruct(personIndex);
    }

    function sf_GetPeopleStruct(uint256 contractIndex) external view returns (SimpleStorage.Person[] memory) {
        return sStorageContracts[contractIndex].getPeopleStruct();
    }

    function sf_GetFavoriteNumber(uint256 contractIndex, string calldata name) external view returns (uint256) {
        return sStorageContracts[contractIndex].getFavoriteNumber(name);
    }

    /* Interaction using interface and address */
    function sfi_Store(address contractAddress, uint256 favoriteNumber) public {
        ISimpleStorage(contractAddress).store(favoriteNumber);
    }

    function sfi_AddPerson(address contractAddress, string calldata name, uint256 favoriteNumber) public {
        ISimpleStorage(contractAddress).addPerson(name, favoriteNumber);
    }

    function sfi_EuclidGCF(address contractAddress, uint256 a, uint256 b)
        public
        pure
        returns (uint256 gcf, uint256 thzero)
    {
        return ISimpleStorage(contractAddress).euclidGCF(a, b);
    }

    function sfi_Retrive(address contractAddress) external view returns (uint256 favoriteNumber, address sender) {
        return ISimpleStorage(contractAddress).retrieve();
    }

    function sfi_GetPerson(address contractAddress, uint256 personIndex)
        external
        view
        returns (string memory, uint256)
    {
        return ISimpleStorage(contractAddress).getPerson(personIndex);
    }

    function sfi_GetPersonStruct(address contractAddress, uint256 personIndex)
        external
        view
        returns (ISimpleStorage.Person memory)
    {
        return ISimpleStorage(contractAddress).getPersonStruct(personIndex);
    }

    function sfi_GetPeopleStruct(address contractAddress) external view returns (ISimpleStorage.Person[] memory) {
        return ISimpleStorage(contractAddress).getPeopleStruct();
    }

    function sfi_GetFavoriteNumber(address contractAddress, string calldata name) external view returns (uint256) {
        return ISimpleStorage(contractAddress).getFavoriteNumber(name);
    }
}
