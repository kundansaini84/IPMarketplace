module MyModule::IPMarketplace {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct IntellectualProperty has store, key {
        owner: address,
        price: u64,
    }

    public fun register_ip(owner: &signer, price: u64) {
        let ip = IntellectualProperty {
            owner: signer::address_of(owner),
            price,
        };
        move_to(owner, ip);
    }

    public fun license_ip(buyer: &signer, seller: address, amount: u64) acquires IntellectualProperty {
        let ip = borrow_global_mut<IntellectualProperty>(seller);
        assert!(amount >= ip.price, 1);

        let payment = coin::withdraw<AptosCoin>(buyer, amount);
        coin::deposit<AptosCoin>(seller, payment);
    }
}
