// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {AddFiveStorage} from "./AddFiveStorage.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UUPSUAddFiveStorage is AddFiveStorage, Initializable, UUPSUpgradeable, OwnableUpgradeable {
    constructor() {
        _disableInitializers();
    }

    function initialize() public reinitializer(2) {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        store(5);
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
