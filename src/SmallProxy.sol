// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract SmallProxy is Proxy {
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    receive() external payable {
        _fallback();
    }

    // since there is no interactive way to just send this data like in remix no use
    // prefer using typecasting this contract in function you are trying to call as it will fallback when it does not find the target
    function getDataToTransact(uint256 favoriteNumber) public pure returns (bytes memory) {
        return abi.encodeWithSignature("store(uint256)", favoriteNumber);
    }

    function readStorageSlot0() public view returns (uint256 valueAtStorageSlot0) {
        assembly {
            valueAtStorageSlot0 := sload(0)
        }
    }

    function readStorageSlot1() public view returns (uint256 valueAtStorageSlot1) {
        assembly {
            valueAtStorageSlot1 := sload(1)
        }
    }

    function readStorageSlot2() public view returns (bytes32 valueAtStorageSlot2) {
        assembly {
            valueAtStorageSlot2 := sload(2)
        }
    }
}
