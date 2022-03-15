from brownie import exceptions, TransactionsV1, EternalStorage
from brownie.convert.datatypes import HexString
import pytest

from scripts.helpful_scripts import get_account


def test_deploy():

    account = get_account()
    es = EternalStorage.deploy({"from": account})
    transactionsV1 = TransactionsV1.deploy(es.address, {"from": account})
    assert transactionsV1.eternalStorage() == es.address

    # Check bad actors
    txID = 0x00000000000000000000000000000001
    customerID = 0x00000000000000000000000000000001
    crc_quantity = 111
    created_at = 1647363814
    with pytest.raises(exceptions.VirtualMachineError):
        tx = transactionsV1.create(txID, customerID, crc_quantity, created_at)

    # Whitelist buffer1V1 in EternalStorage
    tx = es.setProxy(transactionsV1.address)
    tx.wait(1)

    # Create transaction
    tx = transactionsV1.create(txID, customerID, crc_quantity, created_at)
    tx.wait(1)

    # Read the transaction
    (
        txID_,
        customerID_,
        crc_quantity_,
        status_,
        created_at_,
    ) = transactionsV1.getTransaction(txID)
    assert HexString(txID, "32") == txID_
    assert HexString(customerID, "32") == customerID_
    assert crc_quantity == crc_quantity_
    assert 0 == status_
    assert created_at == created_at_
