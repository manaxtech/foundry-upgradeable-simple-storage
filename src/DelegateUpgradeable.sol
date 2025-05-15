// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Target {
    uint256 public value;
    address public sender;
    uint256 public money1;
    uint256 public money2;

    function setValue(uint256 _value) public payable {
        value = _value;
        sender = msg.sender;
        money1 = msg.value;
    }

    function setMoney2() public payable {
        money2 = msg.value;
    }
}

contract ProxyT {
    error Target__FirstCallFailed();
    error Target__SecondCallFailed();

    uint256 public value;
    address public sender;
    uint256 public money1;
    uint256 public money2;
    bytes public someData;

    function set(address _target, uint256 _value) public payable {
        someData = abi.encodeWithSignature("setValue(uint256)", _value);
        (bool succes1,) = _target.delegatecall(someData);
        (bool succes2,) = _target.delegatecall(abi.encode(bytes4(keccak256("setMoney2()"))));
        if (!succes1) revert Target__FirstCallFailed();
        if (!succes2) revert Target__SecondCallFailed();
    }

    function callAnyFunction(address _target, bytes memory _data) public payable {
        (bool success,) = _target.delegatecall(_data);
        require(success);
    }
}
