use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};
use ownable::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use snforge_std::{start_prank, stop_prank, CheatTarget};
use starknet::{get_caller_address};
use super::utils::{deploy_contract, Accounts};

#[test]
fn check_increase_counter_as_owner() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };
    
    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, 'Wrong Increase Counter');
    stop_prank(CheatTarget::One(contract_address));
}


#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn check_increase_counter_as_bad_actor() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher { contract_address };
    
    start_prank(CheatTarget::One(contract_address), Accounts::BAD_ACTOR());
    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, 'Wrong Increase Counter');
    stop_prank(CheatTarget::One(contract_address));
}

#[test]
fn check_transfer_ownership_as_owner() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = IOwnableDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.transfer_ownership(Accounts::NEW_OWNER());
    let current_owner = dispatcher.owner();
    assert(current_owner == Accounts::NEW_OWNER(), 'Owner not changed');
    stop_prank(CheatTarget::One(contract_address));
}

#[test]
fn check_renounce_ownership_as_owner() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = IOwnableDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.renounce_ownership();
    let current_owner = dispatcher.owner();
    assert(current_owner == Zeroable::zero(), 'Owner not renounced');
    stop_prank(CheatTarget::One(contract_address));
}