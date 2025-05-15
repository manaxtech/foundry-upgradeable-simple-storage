// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface ISimpleStorage {
    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    function store(uint256 _favoriteNumber) external;

    function addPerson(string calldata _name, uint256 _favoriteNumber) external;

    function euclidGCF(uint256 a, uint256 b) external pure returns (uint256 gcf, uint256 thzero);

    /* Getter Functions */
    function retrieve() external view returns (uint256, address);

    function getPerson(uint256 index) external view returns (string memory, uint256);

    function getFavoriteNumber(string memory _name) external view returns (uint256);

    function getPersonStruct(uint256 index) external view returns (Person memory);

    function getPeopleStruct() external view returns (Person[] memory);
}
