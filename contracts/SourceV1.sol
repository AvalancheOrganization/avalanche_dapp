// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EternalStorage.sol";

contract SourceV1 is Ownable {
    EternalStorage public eternalStorage;

    constructor(address eternalStorageAddress) {
        eternalStorage = EternalStorage(eternalStorageAddress);
    }

    enum Status {
        ACTIVE,
        INACTIVE
    }

    struct Source {
        bytes32 sourceID;
        string name;
        uint256 volumePerYear;
        string type_;
        string urlContract;
        Status status;
        uint256 startedAt;
    }

    function create(
        bytes32 sourceID,
        string memory name,
        uint256 volumePerYear,
        string memory type_,
        string memory urlContract,
        Status status,
        uint256 startedAt
    ) public onlyOwner {
        updateName(sourceID, name);
        updateVolumePerYear(sourceID, volumePerYear);
        updateType(sourceID, type_);
        updateUrlContract(sourceID, urlContract);
        updateStatus(sourceID, status);
        updateStartedAt(sourceID, startedAt);
    }

    function getSource(bytes32 sourceID)
        public
        view
        returns (
            bytes32,
            string memory,
            uint256,
            string memory,
            string memory,
            Status,
            uint256
        )
    {
        string memory name = getName(sourceID);
        uint256 volumePerYear = getVolumePerYear(sourceID);
        string memory type_ = getType(sourceID);
        string memory urlContract = getUrlContract(sourceID);
        Status status = getStatus(sourceID);
        uint256 startedAt = getStartedAt(sourceID);
        return (
            sourceID,
            name,
            volumePerYear,
            type_,
            urlContract,
            status,
            startedAt
        );
    }

    /* Update */

    function updateName(bytes32 sourceID, string memory name) public onlyOwner {
        bytes32 key = make_key("sourceV1.name", sourceID);
        eternalStorage.setString(key, name);
    }

    function updateVolumePerYear(bytes32 sourceID, uint256 volumePerYear)
        public
        onlyOwner
    {
        bytes32 key = make_key("sourceV1.volume", sourceID);
        eternalStorage.setUint256(key, volumePerYear);
    }

    function updateType(bytes32 sourceID, string memory type_)
        public
        onlyOwner
    {
        bytes32 key = make_key("sourceV1.type", sourceID);
        eternalStorage.setString(key, type_);
    }

    function updateUrlContract(bytes32 sourceID, string memory urlContract)
        public
        onlyOwner
    {
        bytes32 key = make_key("sourceV1.urlContract", sourceID);
        eternalStorage.setString(key, urlContract);
    }

    function updateStatus(bytes32 sourceID, Status status) public onlyOwner {
        bytes32 key = make_key("sourceV1.status", sourceID);
        eternalStorage.setUint256(key, uint256(status));
    }

    function updateStartedAt(bytes32 sourceID, uint256 startedAt)
        public
        onlyOwner
    {
        bytes32 key = make_key("sourceV1.startedAt", sourceID);
        eternalStorage.setUint256(key, startedAt);
    }

    /* Read */

    function getName(bytes32 sourceID) public view returns (string memory) {
        bytes32 key = make_key("sourceV1.name", sourceID);
        return eternalStorage.getString(key);
    }

    function getVolumePerYear(bytes32 sourceID) public view returns (uint256) {
        bytes32 key = make_key("sourceV1.volume", sourceID);
        return eternalStorage.getUint256(key);
    }

    function getType(bytes32 sourceID) public view returns (string memory) {
        bytes32 key = make_key("sourceV1.type", sourceID);
        return eternalStorage.getString(key);
    }

    function getUrlContract(bytes32 sourceID)
        public
        view
        returns (string memory)
    {
        bytes32 key = make_key("sourceV1.urlContract", sourceID);
        return eternalStorage.getString(key);
    }

    function getStatus(bytes32 sourceID) public view returns (Status) {
        bytes32 key = make_key("sourceV1.status", sourceID);
        return Status(eternalStorage.getUint256(key));
    }

    function getStartedAt(bytes32 sourceID) public view returns (uint256) {
        bytes32 key = make_key("sourceV1.startedAt", sourceID);
        return eternalStorage.getUint256(key);
    }

    /* Utils */

    function make_key(string memory prefix, bytes32 id)
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(prefix, id));
    }
}
