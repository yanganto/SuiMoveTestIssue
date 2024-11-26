/// Module: demo2
module demo2::demo2;

// === Structs ===
public struct Cap has key {
    id: UID,
}

public struct T has key, store {
    id: UID,
    admin: ID,
}

// init is special function, which is `internal`, and will not compile with `public` or `public(package)`
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

// Automatically move the all codes from a #[test-only] module to the bottom of a module with the same module name when sui move test
// ex: the line 3 to 28 of /demo2/tests/demo2_tests.move will be cut and paste into here
