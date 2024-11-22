/// Module: demo1
module demo1::demo1;

// === Structs ===
public struct Cap has key {
    id: UID,
}

public struct T has key, store {
    id: UID,
    admin: ID,
}

fun init(ctx: &mut TxContext) {
    let cap = Cap {
            id: object::new(ctx),
    };

    transfer::share_object(T {
        id: object::new(ctx),
        admin: object::id(&cap),
    });

    transfer::transfer(cap, tx_context::sender(ctx));
}

#[test]
fun in_module_test() {
    use sui::test_scenario;
    use std::debug;

    let someone: address = @0xAAAA;

    let mut scenario = test_scenario::begin(someone);
    {
        init(scenario.ctx());
    };

    scenario.next_tx(someone);
    {
        let cap = scenario.take_from_sender<Cap>();
        debug::print(&cap);
        debug::print(&cap.id);
        scenario.return_to_sender(cap);
    };

    // A lot of test code in the scenario

    scenario.end();
}
