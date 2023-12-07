use starknet::{ContractAddress};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};

fn deploy_contract(constructor_args: Array<felt252>) -> ContractAddress {
    let contract = declare('CounterContract');
    return contract.deploy(@constructor_args).unwrap();
}
