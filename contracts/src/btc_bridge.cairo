#[starknet::contract]
mod BTCBridge {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        balances: Map<ContractAddress, u256>,
        total_supply: u256,
        operator: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BTCDeposited: BTCDeposited,
        BTCWithdrawn: BTCWithdrawn,
    }

    #[derive(Drop, starknet::Event)]
    struct BTCDeposited {
        #[key]
        user: ContractAddress,
        amount: u256,
        btc_tx_hash: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct BTCWithdrawn {
        #[key]
        user: ContractAddress,
        amount: u256,
        btc_address: felt252,
    }

    #[constructor]
    fn constructor(ref self: ContractState, operator: ContractAddress) {
        self.operator.write(operator);
    }

    #[abi(embed_v0)]
    impl BTCBridgeImpl of super::IBTCBridge<ContractState> {
        fn mint_wrapped_btc(
            ref self: ContractState,
            user: ContractAddress,
            amount: u256,
            btc_tx_hash: felt252
        ) {
            assert(get_caller_address() == self.operator.read(), 'Unauthorized');
            
            let current_balance = self.balances.entry(user).read();
            self.balances.entry(user).write(current_balance + amount);
            
            let total = self.total_supply.read();
            self.total_supply.write(total + amount);
            
            self.emit(BTCDeposited { user, amount, btc_tx_hash });
        }

        fn burn_wrapped_btc(
            ref self: ContractState,
            amount: u256,
            btc_address: felt252
        ) {
            let caller = get_caller_address();
            let balance = self.balances.entry(caller).read();
            
            assert(balance >= amount, 'Insufficient balance');
            
            self.balances.entry(caller).write(balance - amount);
            
            let total = self.total_supply.read();
            self.total_supply.write(total - amount);
            
            self.emit(BTCWithdrawn { user: caller, amount, btc_address });
        }

        fn balance_of(self: @ContractState, user: ContractAddress) -> u256 {
            self.balances.entry(user).read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }

        fn transfer(
            ref self: ContractState,
            to: ContractAddress,
            amount: u256
        ) -> bool {
            let caller = get_caller_address();
            let sender_balance = self.balances.entry(caller).read();
            
            assert(sender_balance >= amount, 'Insufficient balance');
            
            self.balances.entry(caller).write(sender_balance - amount);
            
            let recipient_balance = self.balances.entry(to).read();
            self.balances.entry(to).write(recipient_balance + amount);
            
            true
        }
    }
}

use starknet::ContractAddress;

#[starknet::interface]
trait IBTCBridge<TContractState> {
    fn mint_wrapped_btc(
        ref self: TContractState,
        user: ContractAddress,
        amount: u256,
        btc_tx_hash: felt252
    );
    fn burn_wrapped_btc(
        ref self: TContractState,
        amount: u256,
        btc_address: felt252
    );
    fn balance_of(self: @TContractState, user: ContractAddress) -> u256;
    fn total_supply(self: @TContractState) -> u256;
    fn transfer(
        ref self: TContractState,
        to: ContractAddress,
        amount: u256
    ) -> bool;
}
