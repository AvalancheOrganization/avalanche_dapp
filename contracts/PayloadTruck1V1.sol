// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EternalStorage.sol";

contract PayloadTruck1V1 is Ownable {
    EternalStorage public eternalStorage;

    constructor(address eternalStorageAddress) {
        eternalStorage = EternalStorage(eternalStorageAddress);
    }

    struct PayloadTruck1 {
        bytes32 payloadID;
        bytes32[5] txIDs;
        bytes32 bufferID;
        bytes32 truckID;
        bytes32 shipID;
        bytes32 sourceID;
        uint256 crcEstimate;
        uint256 deliveredAt;
        string urlVideos;
        string urlPhotos;
    }

    // BlackBox
    function create(
        bytes32 payID,
        bytes32 bufferID,
        bytes32 truckID,
        uint256 crcEstimate,
        uint256 deliveredAt,
        string memory urlVideos,
        string memory urlPhotos
    ) public onlyOwner {
        updateBuffer(payID, bufferID);
        updateTruck(payID, truckID);
        updateCrcEstimate(payID, crcEstimate);
        updateDeliveredAt(payID, deliveredAt);
        updateUrlVideos(payID, urlVideos);
        updateUrlPhotos(payID, urlPhotos);
    }

    // Read
    function getPayload(bytes32 payID)
        public
        view
        returns (
            bytes32,
            bytes32,
            bytes32,
            bytes32,
            bytes32,
            uint256,
            uint256
        )
    {
        bytes32 bufferID = getBuffer(payID);
        bytes32 truckID = getTruck(payID);
        bytes32 shipID = getShip(payID);
        bytes32 sourceID = getSource(payID);
        uint256 crcEstimate = getCrcEstimate(payID);
        uint256 deliveredAt = getDeliveredAt(payID);
        return (
            payID,
            bufferID,
            truckID,
            shipID,
            sourceID,
            crcEstimate,
            deliveredAt
        );
    }

    /* Reconciliation */

    function updateTxs(bytes32 payID, bytes32[5] memory txIDs)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.nTxs", payID);
        uint256 nTxs = eternalStorage.getUint256(key);

        require(
            nTxs + txIDs.length <= 5,
            " # [PayloadTruck1V1] updateTxs with more than 5 Txs"
        );

        for (uint256 i = 0; i < txIDs.length; i++) {
            bytes32 txID = txIDs[i];
            bytes32 key_ = make_key("pay1V1.txIds", i + nTxs, payID);
            eternalStorage.setBytes32(key_, txID);
        }

        nTxs += txIDs.length;
        eternalStorage.setUint256(key, nTxs);
    }

    function deleteTxs(bytes32 payID, bytes32[5] memory txIDs)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.nTxs", payID);
        uint256 nTxs = eternalStorage.getUint256(key);
        uint256 counter = 0;

        for (uint256 i = 0; i < nTxs; i++) {
            bytes32 key_ = make_key("pay1V1.txIds", i, payID);
            bytes32 txID = eternalStorage.getBytes32(key_);
            for (uint256 j = 0; j < txIDs.length; j++) {
                if (txID == txIDs[j]) {
                    eternalStorage.deleteBytes32(key_);
                    counter++;
                    break;
                }
            }
        }

        if (counter > 0) {
            nTxs -= counter;
            eternalStorage.setUint256(key, nTxs);
        }
    }

    /* Update */

    function updateBuffer(bytes32 payID, bytes32 bufferID) public onlyOwner {
        bytes32 key = make_key("pay1V1.bufferID", payID);
        eternalStorage.setBytes32(key, bufferID);
    }

    function updateTruck(bytes32 payID, bytes32 truckID) public onlyOwner {
        bytes32 key = make_key("pay1V1.truckID", payID);
        eternalStorage.setBytes32(key, truckID);
    }

    function updateSource(bytes32 payID, bytes32 sourceID) public onlyOwner {
        bytes32 key = make_key("pay1V1.sourceID", payID);
        eternalStorage.setBytes32(key, sourceID);
    }

    function updateShip(bytes32 payID, bytes32 shipID) public onlyOwner {
        bytes32 key = make_key("pay1V1.shipID", payID);
        eternalStorage.setBytes32(key, shipID);
    }

    function updateCrcEstimate(bytes32 payID, uint256 crcEstimate)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.crcEstimate", payID);
        eternalStorage.setUint256(key, crcEstimate);
    }

    function updateDeliveredAt(bytes32 payID, uint256 deliveredAt)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.deliveredAt", payID);
        eternalStorage.setUint256(key, deliveredAt);
    }

    function updateUrlVideos(bytes32 payID, string memory urlVideos)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.urlVideos", payID);
        eternalStorage.setString(key, urlVideos);
    }

    function updateUrlPhotos(bytes32 payID, string memory urlPhotos)
        public
        onlyOwner
    {
        bytes32 key = make_key("pay1V1.urlPhotos", payID);
        eternalStorage.setString(key, urlPhotos);
    }

    /* Read */

    function getTxs(bytes32 payID) public view returns (bytes32[5] memory) {
        bytes32 key = make_key("pay1V1.nTxs", payID);
        uint256 nTxs = eternalStorage.getUint256(key);
        require(nTxs <= 5, " # [PayloadTruck1V1] Too many Txs for one Payload");
        bytes32[5] memory txs;
        for (uint256 i = 0; i < nTxs; i++) {
            key = make_key("pay1V1.txIds", i, payID);
            txs[i] = eternalStorage.getBytes32(key);
        }
        return txs;
    }

    function getBuffer(bytes32 payID) public view returns (bytes32) {
        bytes32 key = make_key("pay1V1.bufferID", payID);
        return eternalStorage.getBytes32(key);
    }

    function getTruck(bytes32 payID) public view returns (bytes32) {
        bytes32 key = make_key("pay1V1.truckID", payID);
        return eternalStorage.getBytes32(key);
    }

    function getShip(bytes32 payID) public view returns (bytes32) {
        bytes32 key = make_key("pay1V1.shipID", payID);
        return eternalStorage.getBytes32(key);
    }

    function getSource(bytes32 payID) public view returns (bytes32) {
        bytes32 key = make_key("pay1V1.sourceID", payID);
        return eternalStorage.getBytes32(key);
    }

    function getCrcEstimate(bytes32 payID) public view returns (uint256) {
        bytes32 key = make_key("pay1V1.crcEstimate", payID);
        return eternalStorage.getUint256(key);
    }

    function getDeliveredAt(bytes32 payID) public view returns (uint256) {
        bytes32 key = make_key("pay1V1.deliveredAt", payID);
        return eternalStorage.getUint256(key);
    }

    function getUrlVideos(bytes32 payID) public view returns (string memory) {
        bytes32 key = make_key("pay1V1.urlVideos", payID);
        return eternalStorage.getString(key);
    }

    function getUrlPhotos(bytes32 payID) public view returns (string memory) {
        bytes32 key = make_key("pay1V1.urlPhotos", payID);
        return eternalStorage.getString(key);
    }

    /* Utils */

    function make_key(string memory prefix, bytes32 id)
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(prefix, id));
    }

    function make_key(
        string memory prefix,
        uint256 counter,
        bytes32 id
    ) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(prefix, counter, id));
    }
}
