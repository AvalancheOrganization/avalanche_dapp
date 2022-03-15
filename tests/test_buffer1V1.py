from brownie import exceptions, Buffer1V1, EternalStorage
from brownie.convert.datatypes import HexString
import pytest

from scripts.helpful_scripts import get_account


def test_deploy():

    account = get_account()
    es = EternalStorage.deploy({"from": account})
    buffer1V1 = Buffer1V1.deploy(es.address, {"from": account})
    assert buffer1V1.eternalStorage() == es.address

    # Check bad actors
    bufferID = 1  # 0x00000000000000000000000000000001
    long_lat = "2.349014;48.864716"
    crc_estimate = 999
    max_crc_quantity = 2000
    surface = 3000
    status = 1
    with pytest.raises(exceptions.VirtualMachineError):
        tx = buffer1V1.create(
            bufferID, long_lat, crc_estimate, max_crc_quantity, surface, status
        )

    # Whitelist buffer1V1 in EternalStorage
    tx = es.setProxy(buffer1V1.address)
    tx.wait(1)

    # Create transaction
    tx = buffer1V1.create(
        bufferID, long_lat, crc_estimate, max_crc_quantity, surface, status
    )
    tx.wait(1)

    # Read the transaction
    (
        bufferID_,
        long_lat_,
        crc_estimate_,
        max_crc_quantity_,
        surface_,
        url,
        status_,
    ) = buffer1V1.getBuffer(bufferID)
    assert HexString(bufferID, "32") == bufferID_
    assert long_lat == long_lat_
    assert crc_estimate == crc_estimate_
    assert max_crc_quantity == max_crc_quantity_
    assert surface == surface_
    assert status == status_
