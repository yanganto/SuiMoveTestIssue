#[test_only]
module demo2::demo2_tests;
use demo2::demo2::{init, Cap};


#[test]
fun in_test_package() {
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
