// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EternalStorage.sol";

contract TransactionsV1 is Ownable {
    EternalStorage public eternalStorage;

    enum Status {
        ORDERED,
        BOUGHT,
        ROAD_TRANSPORT_1,
        BUFFER_1,
        SHIPPING,
        DEFINITIVE_STORAGE
    }

    struct Transaction {
        string txID;
        string customerID;
        int32 crcQuantity;
        uint256 createdAt;
        Status status;
    }

    constructor(address eternalStorageAddress) {
        eternalStorage = EternalStorage(eternalStorageAddress);
    }

    function create(
        bytes32 txID,
        bytes32 customerID,
        uint256 crcQuantity,
        uint256 createdAt
    ) public onlyOwner {
        updateCustomerID(txID, customerID);
        updateCrcQuantity(txID, crcQuantity);
        updateStatus(txID, Status.ORDERED);
        updateCreatedAt(txID, createdAt);
    }

    function getTransaction(bytes32 txID)
        public
        view
        returns (
            bytes32,
            bytes32,
            uint256,
            Status,
            uint256
        )
    {
        bytes32 customerID = getCustomerID(txID);
        uint256 crcQuantity = getCrcQuantity(txID);
        Status status = getStatus(txID);
        uint256 createdAt = getCreatedAt(txID);
        return (txID, customerID, crcQuantity, status, createdAt);
    }

    /* update */

    function updateCustomerID(bytes32 txID, bytes32 customerID)
        public
        onlyOwner
    {
        bytes32 key = make_key("tx.customerID", txID);
        eternalStorage.setBytes32(key, customerID);
    }

    function updateCrcQuantity(bytes32 txID, uint256 crcQuantity)
        public
        onlyOwner
    {
        bytes32 key = make_key("tx.crcQuantity", txID);
        eternalStorage.setUint256(key, crcQuantity);
    }

    function updateStatus(bytes32 txID, Status status) public onlyOwner {
        bytes32 key = make_key("tx.status", txID);
        eternalStorage.setUint256(key, uint256(status));
    }

    function updateCreatedAt(bytes32 txID, uint256 createdAt) public onlyOwner {
        bytes32 key = make_key("tx.createdAt", txID);
        eternalStorage.setUint256(key, createdAt);
    }

    /* Read */

    function getCustomerID(bytes32 txID) public view returns (bytes32) {
        bytes32 key = make_key("tx.customerID", txID);
        return eternalStorage.getBytes32(key);
    }

    function getCrcQuantity(bytes32 txID) public view returns (uint256) {
        bytes32 key = make_key("tx.crcQuantity", txID);
        return eternalStorage.getUint256(key);
    }

    function getStatus(bytes32 txID) public view returns (Status) {
        bytes32 key = make_key("tx.status", txID);
        Status status = Status(eternalStorage.getUint256(key));
        return status;
    }

    function getCreatedAt(bytes32 txID) public view returns (uint256) {
        bytes32 key = make_key("tx.createdAt", txID);
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
