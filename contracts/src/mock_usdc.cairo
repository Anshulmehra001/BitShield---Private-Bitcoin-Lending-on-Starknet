#[starknet::contract]
mod MockUSDC {
    use starknet::{ContractAddress, get_caller_address, contract_address_const};
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        balances: Map<ContractAddress, u256>,
        allowances: Map<(ContractAddress, ContractAddress), u256>,
        total_supply: u256,
        name: felt252,
        symbol: felt252,
        decimals: u8,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.name.write('Mock USDC');
        self.symbol.write('USDC');
        self.decimals.write(6);
    }

    #[abi(embed_v0)]
    impl MockUSDCImpl of super::IMockUSDC<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self.balances.entry(account).read()
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            self._transfer(sender, recipient, amount);
            true
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let owner = get_caller_address();
            self.allowances.entry((owner, spender)).write(amount);
            self.emit(Approval { owner, spender, value: amount });
            true
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let caller = get_caller_address();
            let current_allowance = self.allowances.entry((sender, caller)).read();
            assert(current_allowance >= amount, 'Insufficient allowance');
            
            self.allowances.entry((sender, caller)).write(current_allowance - amount);
            self._transfer(sender, recipient, amount);
            true
        }

        fn allowance(
            self: @ContractState,
            owner: ContractAddress,
            spender: ContractAddress
        ) -> u256 {
            self.allowances.entry((owner, spender)).read()
        }

        fn mint(ref self: ContractState, to: ContractAddress, amount: u256) {
            let balance = self.balances.entry(to).read();
            self.balances.entry(to).write(balance + amount);
            
            let supply = self.total_supply.read();
            self.total_supply.write(supply + amount);
            
            let zero = contract_address_const::<0>();
            self.emit(Transfer { from: zero, to, value: amount });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _transfer(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            let sender_balance = self.balances.entry(sender).read();
            assert(sender_balance >= amount, 'Insufficient balance');
            
            self.balances.entry(sender).write(sender_balance - amount);
            
            let recipient_balance = self.balances.entry(recipient).read();
            self.balances.entry(recipient).write(recipient_balance + amount);
            
            self.emit(Transfer { from: sender, to: recipient, value: amount });
        }
    }
}

use starknet::ContractAddress;

#[starknet::interface]
trait IMockUSDC<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn decimals(self: @TContractState) -> u8;
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) -> bool;
    fn allowance(
        self: @TContractState,
        owner: ContractAddress,
        spender: ContractAddress
    ) -> u256;
    fn mint(ref self: TContractState, to: ContractAddress, amount: u256);
}
