use core::result::ResultTrait;
use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};
use super::utils::{deploy_contract, Accounts};

#[test]
#[fuzzer(runs: 20, seed: 777)]
fn test_sum(x: felt252, y: felt252) {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };

    assert(dispatcher.sum(x, y) == x + y, 'sum incorrect');
}
