// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EternalStorage is Ownable {
    mapping(address => bool) private proxies;

    mapping(bytes32 => string) public mappingString;
    mapping(bytes32 => uint256) public mappingUint256;
    mapping(bytes32 => int256) public mappingInt256;
    mapping(bytes32 => bytes32) public mappingBytes32;
    mapping(bytes32 => address) public mappingAddress;
    mapping(bytes32 => bool) public mappingBool;

    modifier onlyProxy() {
        require(proxies[msg.sender], "You are not proxy");
        _;
    }

    function setProxy(address newProxy) public onlyOwner {
        proxies[newProxy] = true;
    }

    // getter
    function getString(bytes32 key) public view returns (string memory) {
        return mappingString[key];
    }

    function getUint256(bytes32 key) public view returns (uint256) {
        return mappingUint256[key];
    }

    function getInt256(bytes32 key) public view returns (int256) {
        return mappingInt256[key];
    }

    function getBytes32(bytes32 key) public view returns (bytes32) {
        return mappingBytes32[key];
    }

    function getAddress(bytes32 key) public view returns (address) {
        return mappingAddress[key];
    }

    function getBool(bytes32 key) public view returns (bool) {
        return mappingBool[key];
    }

    // setter
    function setString(bytes32 key, string memory value) public onlyProxy {
        mappingString[key] = value;
    }

    function setUint256(bytes32 key, uint256 value) public onlyProxy {
        mappingUint256[key] = value;
    }

    function setInt256(bytes32 key, int256 value) public onlyProxy {
        mappingInt256[key] = value;
    }

    function setBytes32(bytes32 key, bytes32 value) public onlyProxy {
        mappingBytes32[key] = value;
    }

    function setAddress(bytes32 key, address value) public onlyProxy {
        mappingAddress[key] = value;
    }

    function setBool(bytes32 key, bool value) public onlyProxy {
        mappingBool[key] = value;
    }

    // delete
    function deleteString(bytes32 key) public onlyProxy {
        delete mappingString[key];
    }

    function deleteUint256(bytes32 key) public onlyProxy {
        delete mappingUint256[key];
    }

    function deleteInt256(bytes32 key) public onlyProxy {
        delete mappingInt256[key];
    }

    function deleteBytes32(bytes32 key) public onlyProxy {
        delete mappingBytes32[key];
    }

    function deleteAddress(bytes32 key) public onlyProxy {
        delete mappingAddress[key];
    }

    function deleteBool(bytes32 key) public onlyProxy {
        delete mappingBool[key];
    }
}
