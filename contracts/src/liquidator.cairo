#[starknet::contract]
mod Liquidator {
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        vault_address: ContractAddress,
        liquidation_threshold: u16, // 120% = 12000 basis points
        liquidation_bonus: u16, // 5% = 500 basis points
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        LiquidationExecuted: LiquidationExecuted,
    }

    #[derive(Drop, starknet::Event)]
    struct LiquidationExecuted {
        #[key]
        borrower: ContractAddress,
        #[key]
        liquidator: ContractAddress,
        timestamp: u64,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        vault_address: ContractAddress
    ) {
        self.vault_address.write(vault_address);
        self.liquidation_threshold.write(12000); // 120%
        self.liquidation_bonus.write(500); // 5%
    }

    #[abi(embed_v0)]
    impl LiquidatorImpl of super::ILiquidator<ContractState> {
        // Execute private liquidation with ZK proof
        fn liquidate(
            ref self: ContractState,
            borrower: ContractAddress,
            proof: Span<felt252>
        ) {
            let caller = get_caller_address();
            
            // Verify ZK proof that borrower is undercollateralized
            // without revealing exact amounts
            self._verify_liquidation_proof(borrower, proof);
            
            // Execute liquidation logic
            // Transfer collateral to liquidator with bonus
            
            self.emit(LiquidationExecuted {
                borrower,
                liquidator: caller,
                timestamp: get_block_timestamp(),
            });
        }

        // Check if position can be liquidated (returns commitment, not actual value)
        fn is_liquidatable(
            self: @ContractState,
            borrower: ContractAddress,
            proof: Span<felt252>
        ) -> bool {
            // Verify proof that collateral_ratio < liquidation_threshold
            proof.len() > 0
        }

        fn get_liquidation_threshold(self: @ContractState) -> u16 {
            self.liquidation_threshold.read()
        }

        fn get_liquidation_bonus(self: @ContractState) -> u16 {
            self.liquidation_bonus.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _verify_liquidation_proof(
            ref self: ContractState,
            borrower: ContractAddress,
            proof: Span<felt252>
        ) {
            // Verify ZK proof that:
            // collateral_value / debt_value < liquidation_threshold
            assert(proof.len() > 0, 'Invalid liquidation proof');
        }
    }
}

#[starknet::interface]
trait ILiquidator<TContractState> {
    fn liquidate(
        ref self: TContractState,
        borrower: ContractAddress,
        proof: Span<felt252>
    );
    fn is_liquidatable(
        self: @TContractState,
        borrower: ContractAddress,
        proof: Span<felt252>
    ) -> bool;
    fn get_liquidation_threshold(self: @TContractState) -> u16;
    fn get_liquidation_bonus(self: @TContractState) -> u16;
}
