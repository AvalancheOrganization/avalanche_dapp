from brownie import (
    EternalStorage,
    Buffer1V1,
    PayloadTruck1V1,
    SourceV1,
    TransactionsV1,
    config,
    network,
)
from web3 import Web3

from scripts.helpful_scripts import get_account


def deploy():
    print(
        "Deploying EternalStorage, Buffer1V1, PayloadTruck1V1, SourceV1 and TransactionV1..."
    )
    print(f"Network is: {network.show_active()}")
    account = get_account()
    print(f"Account is: {account}")

    publish_source = config["networks"][network.show_active()].get("verify")
    eternalStorage = EternalStorage.deploy(
        {"from": account}, publish_source=publish_source
    )
    print("EternalStorage deployed")

    buffer1V1 = Buffer1V1.deploy(
        eternalStorage.address, {"from": account}, publish_source=publish_source
    )
    print("Buffer1V1 deployed")

    payload_truckV1 = PayloadTruck1V1.deploy(
        eternalStorage.address, {"from": account}, publish_source=publish_source
    )
    print("PayloadTruckV1 deployed")

    sourceV1 = SourceV1.deploy(
        eternalStorage.address, {"from": account}, publish_source=publish_source
    )
    print("SourceV1 deployed")

    transactionsV1 = TransactionsV1.deploy(
        eternalStorage.address, {"from": account}, publish_source=publish_source
    )
    print("transactionV1 deployed")


def main():
    deploy()
