use ownable::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
use super::utils::{deploy_contract, Accounts, Errors};

#[test]
fn check_constructor_initializable() {
    let initial_counter = 12;
    let contract_address = deploy_contract(initial_counter, true);
    let dispatcher = IOwnableDispatcher { contract_address };
    let current_owner = dispatcher.owner();
    assert(Accounts::OWNER() == current_owner, Errors::NOT_OWNER);
}
