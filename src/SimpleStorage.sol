// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleStorage {
    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    uint256 internal s_myFavoriteNumber;
    Person[] internal s_listOfPeople;
    mapping(string => uint256) internal s_favoriteNumbers;

    function store(uint256 _favoriteNumber) public virtual {
        s_myFavoriteNumber = _favoriteNumber;
    }

    function addPerson(string calldata _name, uint256 _favoriteNumber) public {
        Person memory newPerson = Person(_name, _favoriteNumber);
        s_listOfPeople.push(newPerson);
        s_favoriteNumbers[_name] = _favoriteNumber;
    }

    function euclidGCF(uint256 a, uint256 b) public pure returns (uint256 gcf, uint256 thzero) {
        while (b > 0) {
            (a, b) = (b, a % b);
        }
        (gcf, thzero) = (a, b);
    }

    /* Getter Functions */
    function retrieve() external view returns (uint256, address) {
        return (s_myFavoriteNumber, msg.sender);
    }

    function getPerson(uint256 index) external view returns (string memory, uint256) {
        return (s_listOfPeople[index].name, s_listOfPeople[index].favoriteNumber);
    }

    function getFavoriteNumber(string memory _name) external view returns (uint256) {
        return s_favoriteNumbers[_name];
    }

    function getPersonStruct(uint256 index) external view returns (Person memory) {
        return s_listOfPeople[index];
    }

    function getPeopleStruct() external view returns (Person[] memory) {
        return s_listOfPeople;
    }
}
