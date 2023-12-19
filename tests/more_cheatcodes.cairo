use core::result::ResultTrait;
use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};
use openzeppelin::access::ownable::interface::{IOwnableDispatcher, IOwnableDispatcherTrait};
use snforge_std::{start_prank, stop_prank, CheatTarget};
use snforge_std::{start_roll, stop_roll, start_warp, stop_warp};
use snforge_std::{declare, ContractClassTrait};
use snforge_std::{start_mock_call, stop_mock_call};
use snforge_std::PrintTrait;

use starknet::{get_caller_address,};
use super::utils::{deploy_contract, Accounts};


#[test]
fn test_prank_constructor_roll() {
    let contract = declare('CounterContract');
    let initial_counter = 0;
    let constructor_args = array![initial_counter.into(), Accounts::OWNER().into()];
    let contract_address = contract.precalculate_address(@constructor_args);

    // block number  
    start_roll(CheatTarget::One(contract_address), 777);

    let contract_address = contract.deploy(@constructor_args).unwrap();
    let dispatcher = ICounterContractDispatcher { contract_address: contract_address };

    let blk_number = dispatcher.get_stored_block_number();

    assert(blk_number == 777, 'Block number not equal!');

    stop_roll(CheatTarget::One(contract_address));
}

#[test]
fn test_prank_constructor_warp() {
    let contract = declare('CounterContract');
    let initial_counter = 0;
    let constructor_args = array![initial_counter.into(), Accounts::OWNER().into()];
    let contract_address = contract.precalculate_address(@constructor_args);

    // block timestamp  
    start_warp(CheatTarget::One(contract_address), 1702903986);

    let contract_address = contract.deploy(@constructor_args).unwrap();
    let dispatcher = ICounterContractDispatcher { contract_address: contract_address };

    let blk_timestamp = dispatcher.get_stored_block_timestamp();

    assert(blk_timestamp == 1702903986, 'Block timestamp not equal!');

    stop_warp(CheatTarget::One(contract_address));
}

#[test]
fn test_mock_call() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address: contract_address };

    start_mock_call(contract_address, 'get_stored_block_timestamp', 234);

    let blk_timestamp = dispatcher.get_stored_block_timestamp();

    assert(blk_timestamp == 234, 'Block timestamp not mocked');

    stop_mock_call(contract_address, 'get_stored_block_timestamp');

    let new_blk_timestmap = dispatcher.get_stored_block_timestamp();

    assert(new_blk_timestmap != 234, 'Block timestamp not equal');

    new_blk_timestmap.print();
}

