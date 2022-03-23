import os
import json
from deta import Deta


def store_abi(contract_name):
    if not contract_name.endswith(".json"):
        contract_name = f"{contract_name}.json"
    key = os.getenv("DETA_PROJECT_KEY")
    deta = Deta(key)
    abi_drive = deta.Drive("ABI")
    path_abi = os.path.join("build/contracts/", contract_name)
    abi = json.dumps(json.load(open(path_abi)))
    abi_drive.put(contract_name, abi)
    print(f"{contract_name} stored in Deta!")
