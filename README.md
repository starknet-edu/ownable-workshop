# Ownable Workshop

In this workshop, you will learn how to create an Ownable contract, which assigns a `ContractAddress` to be the owner of the contract. In addition, you will learn about how components can be implemented and finally use OpenZeppelin's Ownable component.

This workshop is a continuation of the [Counter Workshop](https://github.com/starknet-edu/counter-workshop/tree/master). If you haven't completed it, please do so.

After completing each step, run the associated script to verify it has been implemented correctly.

Use the [Cairo book](https://book.cairo-lang.org/ch00-00-introduction.html) and the [Starknet docs](https://docs.starknet.io/documentation/) as a reference.

## Setup

1. Clone this repository
2. Create a new file called `counter.cairo` inside the `src` folder
3. Copy the final code from the [Counter Workshop](https://github.com/starknet-edu/counter-workshop/blob/step6/src/prev_solution.cairo)

> **Note:** You'll be working on the `counter.cairo` and `ownable.cairo` files to complete the requirements of each step. The folder `prev_solution` will show up in future steps as a way to catch up with the workshop if you fall behind. **Don't modify that file**.

## Step 1

### Goal

In this step, you will need to do the following:

- store a new variable named `owner` as `ContractAddress` type in the `Storage` struct
- modify the constructor function so that it accepts a new input variable named `initial_owner` and then updates the `owner` variable from the `Storage` with this value
- implement a public function named `owner()` which returns the value of the `owner` variable

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- create a new public interface called `IOwnable<T>{}` and add the function `owner()`
- create a new `impl` which implements the `IOwnable` interface and add the `#[abi(embed_v0)]` to expose the `impl`

## Step 2

### Goal

In this step, you will need to do the following:

- create a private function named `assert_only_owner` which checks:
- protect the `increase_counter` function with the `assert_only_owner` function

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Requirements

The `assert_only_owner` function should:

- check that the `caller` is not the zero address, otherwise, it will panic with the following message `'Caller is the zero address`
- check that the `caller` is the same as the `owner` which is stored in the `Storage`, otherwise, it will panic with the following message `'Caller is not the owner'`

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- You can read who the caller is by using the syscall `get_caller_address` available in the `starknet` module
- You can check for the zero address with the `.is_zero()` function on the variable itself
- To read more about Private Functions, check [Chapter 12.3.2 Private functions](https://book.cairo-lang.org/ch99-01-03-02-contract-functions.html#3-private-functions)

## Step 3

### Goal

In this step, you will need to do create a public function named `transfer_ownership()` which receives as input variable `new_owner` as `ContractAddress` type and updates `owner` from the `Storage` with the new value.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Requirements

The `transfer_ownership()` function should:

- be in the `IOwnable` interface
- check that the `new_owner` variable is not the zero address, otherwise, it will panic with the following message `'New owner is the zero address'`
- check that only the owner can access the function
- update the `owner` variable with the `new_owner`

> **Note:** You can implement a private function which only updates the `owner` variable with the `new_owner` variable. We will call this private function several times and it makes the code modular. You can name this private function as `_transfer_ownership()`.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- Make sure that the panic messages are the same as stated in the **Requirements** sections, otherwise, some test will fail.

## Step 4

### Goal

In this step, you will need to do the following:

- implement an event named `OwnershipTransferred` which emits the `previous_owner` and the `new_owner` variables
- emit this event when you successfully transfer the ownership of the contract

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

Events are custom data structures that are emitted by a contract. More information about Events can be found in [Chapter 12.3.3 - Contract Events](https://book.cairo-lang.org/ch99-01-03-03-contract-events.html).

## Step 5

### Goal

In this step, you will need to do create a public function named `renounce_ownership()` which removes the current `owner` and change it to the zero address.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Requirements

The `renounce_ownership()` function should:

- be in the `IOwnable` interface
- check that only the owner can call this function

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- You can use `Zeroable::zero()` for the zero address which is available in the `starknet` module
- You can use the private function `_transfer_ownership` that you created in `Step 3` to avoid code duplication

## Step 6

### Goal

In this step, you will need to do create a private function called `initializer()`, which initializes the owner variable. Modify the constructor function so that you call the private function `initializer()` to initialize the owner.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- You can use the private function `_transfer_ownership` that you created in the `Step 3` to avoid code duplication

## Step 7

### Goal

In this step, you will need to create a new file named `ownable.cairo` and move all the related code to the `Ownable` exercise. The `ownable.cairo` should be created as a normal starknet contract.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Requirements

- name the `ownable.cairo` contract as the following:

```rust
#[starknet::contract]
mod OwnableComponent {
}
```

- add all the relevant code to this file, this includes:
  - the interface
  - the implementation of the interface
  - storage to store the `owner` variable
  - the private functions

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

## Step 8

### Goal

In this step, you will change the `ownable.cairo` from a starknet contract to a starknet component. Then, you will import the component and use it within your `counter.cairo`.

Before working on this step, make sure to read [Chapter 12.4: Components](https://book.cairo-lang.org/ch99-01-05-00-components.html) and see how Components work.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Requirements

- the name of your component impl block should be `OwnableImpl`
- use the `component!()` in the `counter.cairo` to i
- in your `counter.cairo` store the component's storage path as `ownable` inside the `Storage`
- in your `counter.cairo` store the component's events path as `OwnableEvent`

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- to migrate a contract to a component you will need to:

  - use the `#[starknet::component]` instead of the `#[starknet::contract]`
  - change the `#[abi(embed_v0)]` to `#[embeddable_as(name)]` for the impl block
  - add generic parameters for the impl block such as `TContractState` and `+HasComponent<TContractState>`
  - change the `self` argument to `ComponentState<TContractState>`

    > **Note:** Read more on [Chapter 12.4: Migrating a Contract to a Component](https://book.cairo-lang.org/ch99-01-05-00-components.html?highlight=compon#migrating-a-contract-to-a-component)

- to use the component inside the `counter.cairo` you will need to

  - declare the component with the `component!()` macro`
  - add the path to the component's storage and events to your contract's `Storage` and `Events`
  - instantiate the component's implementation

    > **Note:** Read more on [Chapter 12.4: Using Components inside a contract](https://book.cairo-lang.org/ch99-01-05-00-components.html?highlight=compon#using-components-inside-a-contract)

## Step 9

### Goal

In this step, you will use [OpenZeppelin's Ownable implementation](https://github.com/OpenZeppelin/cairo-contracts/tree/main/src/access/ownable) in your contract. You will only need to change the import path of the `OwnableComponent` to match OpenZeppelin's.

> **Note:** If you fell behind, the folder prev_solution contains the solution to the previous step.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

### Hints

- OpenZepplin library has already been added to your `Scarb.toml` configuration
- you only need modify your ownable import to match the [OwnableComponent](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/access/ownable/ownable.cairo)

## Step 10 (final)

### Goal

Check that you have correctly created an account contract for Starknet by running the full test suite:

```bash
$ snforge test
```

If the test suite passes, congratulations, you have created your first custom Starknet Counter Contract which implement the component feature and succesfully uses the OpenZeppelin library.
