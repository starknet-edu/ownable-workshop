use core::array::ArrayTrait;
use starknet::{ContractAddress, Into, TryInto};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};

mod Errors {
    // Counter
    const NOT_EQUAL: felt252 = 'Stored value not equal';
    const NOT_INCREASED: felt252 = 'Value not increased';

    // Ownable
    const NOT_OWNER: felt252 = 'Caller is not the owner';
}

mod Accounts {
    use traits::TryInto;
    use starknet::{ContractAddress};

    fn OWNER() -> ContractAddress {
        'owner'.try_into().unwrap()
    }

    fn NEW_OWNER() -> ContractAddress {
        'new_owner'.try_into().unwrap()
    }

    fn BAD_ACTOR() -> ContractAddress {
        'bad_actor'.try_into().unwrap()
    }
}

fn deploy_contract(initial_value: u32, kill_switch: bool) -> ContractAddress {
    let contract = declare('KillSwitch');
    let constructor_args = array![kill_switch.into()];
    let contract_address = contract.deploy(@constructor_args).unwrap();

    let contract = declare('Counter');
    let constructor_args: Array<felt252> = array![
        initial_value.into(), contract_address.into(), Accounts::OWNER().into()
    ];
    contract.deploy(@constructor_args).unwrap()
}
