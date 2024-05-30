
module soltoken_demo::sol {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::url;

   
    struct SOL has drop {}

    fun init(witness: SOL, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency( witness,
            8,
            b"SOL",
            b"SOL",
            b"Fake SOL on Sui testnet for testing only maintained by Typus Lab",
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/Typus-Lab/typus-asset/main/assets/SOL.svg")),
            ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<SOL>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

  
    public entry fun burn(treasury_cap: &mut TreasuryCap<SOL>, coin: Coin<SOL>) {
        coin::burn(treasury_cap, coin);
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(SOL {}, ctx)
    }
}