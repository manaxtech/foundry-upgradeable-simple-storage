// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {SimpleStorage} from "./SimpleStorage.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UUPSUSimpleStorage is SimpleStorage, Initializable, UUPSUpgradeable, OwnableUpgradeable {
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        store(3);
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
