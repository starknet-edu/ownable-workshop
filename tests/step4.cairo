use ownable::counter::{IOwnableDispatcher, IOwnableDispatcherTrait};
use snforge_std::{
    spy_events, EventSpy, EventFetcher, event_name_hash, EventAssertions, Event, SpyOn
};
use snforge_std::{start_prank, stop_prank, CheatTarget, PrintTrait};
use super::utils::{deploy_contract, Accounts, Errors};

#[test]
fn spy_transfer_event() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = IOwnableDispatcher { contract_address };

    let mut spy = spy_events(SpyOn::One(contract_address));

    start_prank(CheatTarget::One(contract_address), Accounts::OWNER());
    dispatcher.transfer_ownership(Accounts::NEW_OWNER());
    let current_owner = dispatcher.owner();
    assert(current_owner == Accounts::NEW_OWNER(), 'Owner not changed');

    spy.fetch_events();

    assert(spy.events.len() == 1, 'There should be one event');

    let (from, event) = spy.events.at(0);
    assert(from == @contract_address, 'Emitted from wrong address');
    assert(event.keys.len() == 1, 'There should be one key');
    assert(event.keys.at(0) == @event_name_hash('OwnershipTransferred'), 'Wrong event name');
    assert(event.data.len() == 2, 'There should be one data');

    stop_prank(CheatTarget::One(contract_address));
}