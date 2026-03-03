#[starknet::contract]
mod BitShieldVault {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        collateral_amounts: Map<ContractAddress, u256>,
        debt_amounts: Map<ContractAddress, u256>,
        total_tvl: u256,
        total_borrowed: u256,
        collateral_ratio: u16,
        owner: ContractAddress,
        btc_price: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposited: Deposited,
        Borrowed: Borrowed,
        Repaid: Repaid,
        Liquidated: Liquidated,
    }

    #[derive(Drop, starknet::Event)]
    struct Deposited {
        #[key]
        user: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Borrowed {
        #[key]
        user: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Repaid {
        #[key]
        user: ContractAddress,
        timestamp: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Liquidated {
        #[key]
        user: ContractAddress,
        timestamp: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.collateral_ratio.write(15000);
        self.btc_price.write(60000_00000000);
    }

    #[abi(embed_v0)]
    impl BitShieldVaultImpl of super::IBitShieldVault<ContractState> {
        fn deposit_collateral(ref self: ContractState, encrypted_amount: u256) {
            let caller = get_caller_address();
            assert(encrypted_amount > 0, 'Amount must be positive');
            
            let current = self.collateral_amounts.entry(caller).read();
            self.collateral_amounts.entry(caller).write(current + encrypted_amount);
            
            let tvl = self.total_tvl.read();
            self.total_tvl.write(tvl + encrypted_amount);
            
            self.emit(Deposited {
                user: caller,
                timestamp: get_block_timestamp(),
            });
        }

        fn borrow(ref self: ContractState, encrypted_amount: u256) {
            let caller = get_caller_address();
            assert(encrypted_amount > 0, 'Amount must be positive');
            
            let collateral = self.collateral_amounts.entry(caller).read();
            assert(collateral > 0, 'No collateral');
            
            let current_debt = self.debt_amounts.entry(caller).read();
            self.debt_amounts.entry(caller).write(current_debt + encrypted_amount);
            
            let total_borrowed = self.total_borrowed.read();
            self.total_borrowed.write(total_borrowed + encrypted_amount);
            
            self.emit(Borrowed {
                user: caller,
                timestamp: get_block_timestamp(),
            });
        }

        fn repay(ref self: ContractState, encrypted_amount: u256) {
            let caller = get_caller_address();
            let current_debt = self.debt_amounts.entry(caller).read();
            
            assert(current_debt >= encrypted_amount, 'Repay exceeds debt');
            
            self.debt_amounts.entry(caller).write(current_debt - encrypted_amount);
            
            let total_borrowed = self.total_borrowed.read();
            self.total_borrowed.write(total_borrowed - encrypted_amount);
            
            self.emit(Repaid {
                user: caller,
                timestamp: get_block_timestamp(),
            });
        }

        fn withdraw_collateral(ref self: ContractState, encrypted_amount: u256) {
            let caller = get_caller_address();
            let collateral = self.collateral_amounts.entry(caller).read();
            let debt = self.debt_amounts.entry(caller).read();
            
            assert(collateral >= encrypted_amount, 'Insufficient collateral');
            assert(debt == 0, 'Must repay debt first');
            
            self.collateral_amounts.entry(caller).write(collateral - encrypted_amount);
            
            let tvl = self.total_tvl.read();
            self.total_tvl.write(tvl - encrypted_amount);
        }

        fn get_collateral(self: @ContractState, user: ContractAddress) -> u256 {
            self.collateral_amounts.entry(user).read()
        }

        fn get_debt(self: @ContractState, user: ContractAddress) -> u256 {
            self.debt_amounts.entry(user).read()
        }

        fn get_tvl(self: @ContractState) -> u256 {
            self.total_tvl.read()
        }

        fn get_total_borrowed(self: @ContractState) -> u256 {
            self.total_borrowed.read()
        }

        fn get_collateral_ratio(self: @ContractState) -> u16 {
            self.collateral_ratio.read()
        }

        fn get_btc_price(self: @ContractState) -> u256 {
            self.btc_price.read()
        }

        fn update_btc_price(ref self: ContractState, new_price: u256) {
            assert(get_caller_address() == self.owner.read(), 'Only owner');
            self.btc_price.write(new_price);
        }
    }
}

use starknet::ContractAddress;

#[starknet::interface]
trait IBitShieldVault<TContractState> {
    fn deposit_collateral(ref self: TContractState, encrypted_amount: u256);
    fn borrow(ref self: TContractState, encrypted_amount: u256);
    fn repay(ref self: TContractState, encrypted_amount: u256);
    fn withdraw_collateral(ref self: TContractState, encrypted_amount: u256);
    fn get_collateral(self: @TContractState, user: ContractAddress) -> u256;
    fn get_debt(self: @TContractState, user: ContractAddress) -> u256;
    fn get_tvl(self: @TContractState) -> u256;
    fn get_total_borrowed(self: @TContractState) -> u256;
    fn get_collateral_ratio(self: @TContractState) -> u16;
    fn get_btc_price(self: @TContractState) -> u256;
    fn update_btc_price(ref self: TContractState, new_price: u256);
}
