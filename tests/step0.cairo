use starknet::{ContractAddress};
use super::utils::{Errors};
use snforge_std::{
    spy_events, EventSpy, EventFetcher, event_name_hash, EventAssertions, Event, SpyOn
};
use snforge_std::{PrintTrait, declare, cheatcodes::contract_class::ContractClassTrait};
use kill_switch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};
use ownable::counter::{ICounterDispatcher, ICounterDispatcherTrait};



#[test]
fn check_stored_counter() {
    let initial_counter = 12;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = ICounterDispatcher { contract_address };
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter, Errors::NOT_EQUAL);
}

#[test]
fn increase_counter() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = ICounterDispatcher { contract_address };

    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, Errors::NOT_EQUAL);
}

#[test]
fn test_counter_event() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = ICounterDispatcher { contract_address };

    let mut spy = spy_events(SpyOn::One(contract_address));
    dispatcher.increase_counter();

    spy.fetch_events();
    assert(spy.events.len() == 1, 'There should be one event');

    let (from, event) = spy.events.at(0);
    assert(from == @contract_address, 'Emitted from wrong address');

    assert(event.keys.len() == 1, 'There should be one key');

    assert(event.keys.at(0) == @event_name_hash('CounterIncreased'), 'Wrong event name');

    assert(event.data.len() == 1, 'There should be one data');
}

#[test]
fn test_counter_contract_with_kill_switch_activated() {
    let initial_counter = 15;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = ICounterDispatcher { contract_address };

    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, Errors::NOT_INCREASED);
}

fn deploy_contract(initial_value: u32, kill_switch: bool) -> ContractAddress {
    let contract = declare('KillSwitch');
    let constructor_args = array![kill_switch.into()];
    let contract_address = contract.deploy(@constructor_args).unwrap();

    let contract = declare('Counter');
    let constructor_args = array![initial_value.into(), contract_address.into()];
    return contract.deploy(@constructor_args).unwrap();
}