from brownie import exceptions, SourceV1, EternalStorage
from brownie.convert.datatypes import HexString
import pytest

from scripts.helpful_scripts import get_account


def test_deploy():

    account = get_account()
    es = EternalStorage.deploy({"from": account})
    sourceV1 = SourceV1.deploy(es.address, {"from": account})
    assert sourceV1.eternalStorage() == es.address

    # Check bad actors
    sourceID = 0x00000000000000000000000000000009
    name = "RecupBois"
    volume_per_year = 200
    type_ = "renewable"
    url_contract = ""
    status = 0
    started_at = 1647364141
    with pytest.raises(exceptions.VirtualMachineError):
        tx = sourceV1.create(
            sourceID, name, volume_per_year, type_, url_contract, status, started_at
        )

    # Whitelist buffer1V1 in EternalStorage
    tx = es.setProxy(sourceV1.address)
    tx.wait(1)

    # Create transaction
    tx = sourceV1.create(
        sourceID, name, volume_per_year, type_, url_contract, status, started_at
    )
    tx.wait(1)

    # Read the transaction
    (
        sourceID_,
        name_,
        volume_per_year_,
        type__,
        url_contract_,
        status_,
        started_at_,
    ) = sourceV1.getSource(sourceID)
    assert HexString(sourceID, "32") == sourceID_
    assert name == name_
    assert volume_per_year == volume_per_year_
    assert type_ == type__
    assert url_contract == url_contract_
    assert status == status_
    assert started_at == started_at_
