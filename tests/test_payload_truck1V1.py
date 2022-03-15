from aiohttp import payload
from brownie import exceptions, PayloadTruck1V1, EternalStorage
from brownie.convert.datatypes import HexString
import pytest

from scripts.helpful_scripts import get_account


def test_deploy():

    account = get_account()
    es = EternalStorage.deploy({"from": account})
    payloadV1 = PayloadTruck1V1.deploy(es.address, {"from": account})
    assert payloadV1.eternalStorage() == es.address

    # Check bad actors
    payID = 0x00000000000000000000000000000009
    bufferID = 0x00000000000000000000000000000002
    truckID = 0x00000000000000000000000000000003
    crc_estimate = 90
    delivered_at = 1647364141
    url_videos = "https://videos1.mp4"
    url_photos = "https://photos1.mp4"
    with pytest.raises(exceptions.VirtualMachineError):
        tx = payloadV1.create(
            payID, bufferID, truckID, crc_estimate, delivered_at, url_videos, url_photos
        )

    # Whitelist buffer1V1 in EternalStorage
    tx = es.setProxy(payloadV1.address)
    tx.wait(1)

    # Create transaction
    tx = payloadV1.create(
        payID, bufferID, truckID, crc_estimate, delivered_at, url_videos, url_photos
    )
    tx.wait(1)

    # Read the transaction
    (
        payID_,
        bufferID_,
        truckID_,
        shipID_,
        sourceID_,
        crc_estimate_,
        delivered_at_,
    ) = payloadV1.getPayload(payID)
    assert HexString(payID, "32") == payID_
    assert HexString(bufferID, "32") == bufferID_
    assert HexString(truckID, "32") == truckID_
    assert HexString(0, "32") == shipID_
    assert HexString(0, "32") == sourceID_
    assert crc_estimate == crc_estimate_
    assert delivered_at == delivered_at_
