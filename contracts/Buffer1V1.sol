// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EternalStorage.sol";

contract Buffer1V1 is Ownable {
    EternalStorage public eternalStorage;

    enum Status {
        EMPTY,
        LOADING,
        FULL,
        UNLOADING,
        CLOSED
    }

    struct Buffer {
        bytes32 bufferID;
        string longLat;
        uint256 crcEstimate;
        uint256 maxCrcQuantity;
        uint256 surface;
        string urlPhotosStopMotion;
        Status status;
    }

    constructor(address eternalStorageAddress) {
        eternalStorage = EternalStorage(eternalStorageAddress);
    }

    function create(
        bytes32 buffID,
        string memory longLat,
        uint256 crcEstimate,
        uint256 maxCrcQuantity,
        uint256 surface,
        Status status
    ) public onlyOwner {
        updateLongLat(buffID, longLat);
        updateCrcEstimate(buffID, crcEstimate);
        updateMaxCrcQuantity(buffID, maxCrcQuantity);
        updateSurface(buffID, surface);
        updateStatus(buffID, status);
    }

    function getBuffer(bytes32 buffID) public view returns (Buffer memory) {
        string memory longLat = getLongLat(buffID);
        uint256 crcEstimate = getCrcEstimate(buffID);
        uint256 maxCrcQuantity = getMaxCrcQuantity(buffID);
        uint256 surface = getSurface(buffID);
        string memory urlPhotosStopMotion = getUrlPhotosStopMotion(buffID);
        Status status = getStatus(buffID);
        return
            Buffer(
                buffID,
                longLat,
                crcEstimate,
                maxCrcQuantity,
                surface,
                urlPhotosStopMotion,
                status
            );
    }

    /* Update */

    function updateLongLat(bytes32 buffID, string memory longLat)
        public
        onlyOwner
    {
        bytes32 key = make_key("buff1V1.longLat", buffID);
        eternalStorage.setString(key, longLat);
    }

    function updateCrcEstimate(bytes32 buffID, uint256 crcEstimate)
        public
        onlyOwner
    {
        bytes32 key = make_key("buff1V1.crcEstimate", buffID);
        eternalStorage.setUint256(key, crcEstimate);
    }

    function updateMaxCrcQuantity(bytes32 buffID, uint256 maxCrcQuantity)
        public
        onlyOwner
    {
        bytes32 key = make_key("buff1V1.maxCrcQuantity", buffID);
        eternalStorage.setUint256(key, maxCrcQuantity);
    }

    function updateSurface(bytes32 buffID, uint256 surface) public onlyOwner {
        bytes32 key = make_key("buff1V1.surface", buffID);
        eternalStorage.setUint256(key, surface);
    }

    function updateUrlPhotosStopMotion(
        bytes32 buffID,
        string memory urlPhotosStopMotion
    ) public onlyOwner {
        bytes32 key = make_key("buff1V1.urlPhotoStopMotion", buffID);
        eternalStorage.setString(key, urlPhotosStopMotion);
    }

    function updateStatus(bytes32 buffID, Status status) public onlyOwner {
        bytes32 key = make_key("buff1V1.status", buffID);
        eternalStorage.setUint256(key, uint256(status));
    }

    /* Read */

    function getLongLat(bytes32 buffID) public view returns (string memory) {
        bytes32 key = make_key("buff1V1.longLat", buffID);
        return eternalStorage.getString(key);
    }

    function getCrcEstimate(bytes32 buffID) public view returns (uint256) {
        bytes32 key = make_key("buff1V1.crcEstimate", buffID);
        return eternalStorage.getUint256(key);
    }

    function getMaxCrcQuantity(bytes32 buffID) public view returns (uint256) {
        bytes32 key = make_key("buff1V1.maxCrcQuantity", buffID);
        return eternalStorage.getUint256(key);
    }

    function getSurface(bytes32 buffID) public view returns (uint256) {
        bytes32 key = make_key("buff1V1.surface", buffID);
        return eternalStorage.getUint256(key);
    }

    function getUrlPhotosStopMotion(bytes32 buffID)
        public
        view
        returns (string memory)
    {
        bytes32 key = make_key("buff1V1.urlPhotoStopMotion", buffID);
        return eternalStorage.getString(key);
    }

    function getStatus(bytes32 buffID) public view returns (Status) {
        bytes32 key = make_key("buff1V1.status", buffID);
        return Status(eternalStorage.getUint256(key));
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
