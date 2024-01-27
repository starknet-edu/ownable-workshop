use starknet::ContractAddress;

#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T);
}

#[starknet::interface]
trait IOwnable<T> {
    fn owner(self: @T) -> ContractAddress;
    fn transfer_ownership(ref self: T, new_owner: ContractAddress);
}

#[starknet::contract]
mod Counter {
    use starknet::{ContractAddress, get_caller_address, Zeroable};
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
        OwnershipTransferred: OwnershipTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        counter: u32
    }

    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        previous_owner: ContractAddress,
        new_owner: ContractAddress,
    }


    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }
        fn increase_counter(ref self: ContractState) {
            let is_active = self.kill_switch.read().is_active();
            self.assert_only_owner();
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
        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), 'New owner is the zero address');
            self.assert_only_owner();
            self._transfer_ownership(new_owner);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn assert_only_owner(self: @ContractState) {
            let owner: ContractAddress = self.owner.read();
            let caller = get_caller_address();
            assert(!caller.is_zero(), 'Caller is the zero address');
            assert(caller == owner, 'Caller is not the owner');
        }

        fn _transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            let previous_owner: ContractAddress = self.owner.read();
            self.owner.write(new_owner);
            self
                .emit(
                    OwnershipTransferred { previous_owner: previous_owner, new_owner: new_owner }
                );
        }
    }
}
