# SuiMoveTestIssue

This repo demonstrates the 2 restrictions of test module for sui.

- Test scenario with `init` can not be used in a test module
- The inner field of struct can not be debugged in a test module

### Description & Explain
`demo1` and `demo2` are the same, and the testcases are the same,
the only different is one is in the module and the other is in the test module.

sui move test on demo1 
```console
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING demo1
Running Move unit tests
[debug] 0x0::demo1::Cap {
  id: 0x2::object::UID {
    id: 0x2::object::ID {
      bytes: @0x34401905bebdf8c04f3cd5f04f442a39372c8dc321c29edfb4f9cb30b23ab96
    }
  }
}
[debug] 0x2::object::UID {
  id: 0x2::object::ID {
    bytes: @0x34401905bebdf8c04f3cd5f04f442a39372c8dc321c29edfb4f9cb30b23ab96
  }
}
[ PASS    ] demo1::demo1::in_module_test
Test result: OK. Total tests: 1; passed: 1; failed: 0
```

sui move test on demo2
```console
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING demo2
error[E04001]: restricted visibility
   ┌─ ./tests/demo2_tests.move:15:9
   │
15 │         init(scenario.ctx());
   │         ^^^^^^^^^^^^^^^^^^^^ Invalid call to internal function 'demo2::demo2::init'
   │
   ┌─ ./sources/demo2.move:15:5
   │
15 │ fun init(ctx: &mut TxContext) {
   │     ---- This function is internal to its module. Only 'public' and 'public(package)' functions can be called outside of their module

error[E04001]: restricted visibility
   ┌─ ./tests/demo2_tests.move:22:23
   │
22 │         debug::print(&cap.id);
   │                       ^^^^^^ Invalid access of field 'id' on the struct 'demo2::demo2::Cap'. The field 'id' can only be accessed within the module 'demo2::demo2' since it defines 'Cap'
```

Function `init` is a special one, which can not be `public` or `public(package)`, but it can not used in other test module due to the visiblity.
The inner field of a struct also has same issue.
Scenario test cases are usually big and seperate in different file/module ,and using `init` is reasonable but forbidden.

### Environment
The test environment based on sui 2020-10-24, `0de6c86795fa776f566195d92af651faf2fbdbab`.
It is easy to run the sui with `nix run github:yanganto/sui/flake-2024-10-24`, and produce the same result.
The Github Action reproduce the result.
