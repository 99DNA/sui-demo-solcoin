// SPDX-License-Identifier: Apache-2.0

#[test_only]
module soltoken_demo::sol_tests {

    use soltoken_demo::sol::{Self, SOL};
    use sui::coin::{Coin, TreasuryCap};
    use sui::test_scenario::{Self, next_tx, ctx};

    #[test]
    fun mint_burn() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let scenario = test_scenario::begin(addr1);
        
        // Run the managed coin module init function
        {
            sol::test_init(ctx(&mut scenario))
        };

        // Mint a `Coin<SOL>` object
        next_tx(&mut scenario, addr1);
        {
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<SOL>>(&scenario);
            sol::mint(&mut treasurycap, 100, addr1, test_scenario::ctx(&mut scenario));
            test_scenario::return_to_address<TreasuryCap<SOL>>(addr1, treasurycap);
        };

        // Burn a `Coin<SOL>` object
        next_tx(&mut scenario, addr1);
        {
            let coin = test_scenario::take_from_sender<Coin<SOL>>(&scenario);
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<SOL>>(&scenario);
            sol::burn(&mut treasurycap, coin);
            test_scenario::return_to_address<TreasuryCap<SOL>>(addr1, treasurycap);
        };

        // Cleans up the scenario object
        test_scenario::end(scenario);
    }

}