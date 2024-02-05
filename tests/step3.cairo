use ownable::counter::{IOwnableDispatcher, IOwnableDispatcherTrait};
use super::utils::{deploy_contract, Accounts, Errors};
use snforge_std::{start_prank, stop_prank, CheatTarget};

#[test]
fn check_transfer_ownership_as_owner() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = IOwnableDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.transfer_ownership(Accounts::NEW_OWNER());
    let current_owner = dispatcher.owner();
    assert(current_owner == Accounts::NEW_OWNER(), 'Owner not changed');
    stop_prank(CheatTarget::One(contract_address));
}

#[test]
#[should_panic(expected: ('New owner is the zero address',))]
fn check_transfer_ownership_to_zero_address() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = IOwnableDispatcher { contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.transfer_ownership(Accounts::ZERO());
    let current_owner = dispatcher.owner();
    assert(current_owner == Accounts::NEW_OWNER(), 'Owner not changed');
    stop_prank(CheatTarget::One(contract_address));
}
