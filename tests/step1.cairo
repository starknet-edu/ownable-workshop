use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};

use super::utils::{deploy_contract};

#[test]
fn check_stored_counter() {
    let initial_counter = 12;
    let constructor_args = array![initial_counter.into()];
    let contract_address = deploy_contract(constructor_args);
    let dispatcher = ICounterContractDispatcher { contract_address };
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter, 'Wrong Stored Counter');
}
