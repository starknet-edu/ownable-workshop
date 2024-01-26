use starknet::ContractAddress;

#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T);
}

#[starknet::interface]
trait IOwnable<T> {
    fn owner(self: @T) -> ContractAddress;
}

#[starknet::contract]
mod Counter {
    use starknet::{ContractAddress};
    use super::{ICounter, IOwnable};
    use kill_switch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};

    #[storage]
    struct Storage {
        counter: u32,
        kill_switch: IKillSwitchDispatcher,
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        initial_counter: u32,
        kill_switch_address: ContractAddress,
        initial_owner: ContractAddress
    ) {
        self.counter.write(initial_counter);
        self.kill_switch.write(IKillSwitchDispatcher { contract_address: kill_switch_address });
        self.owner.write(initial_owner);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        counter: u32
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }
        fn increase_counter(ref self: ContractState) {
            let is_active = self.kill_switch.read().is_active();

            if is_active {
                let current_counter = self.counter.read();
                self.counter.write(current_counter + 1);
                self.emit(CounterIncreased { counter: self.counter.read() })
            }
        }
    }

    #[abi(embed_v0)]
    impl OwnableImpl of IOwnable<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}
