# Ownable Workshop

In this workshop you will learn how to create an Ownable contract, which assigns a Contract Address to be the owner of the contract. In addition, you will learn about how components can be implement and finally use OpenZeppelin's Ownable contract.

After completing each step, run the associated script to verify it has been implemented correctly.

Use the [Cairo book](https://book.cairo-lang.org/ch00-00-introduction.html) and the [Starknet docs](https://docs.starknet.io/documentation/) as a reference.

## Setup

1. Clone this repository
2. Create a new file called `counter.cairo` inside the `src` folder
3. Copy the following code into the file

```rust
#[starknet::contract]
mod CounterContract {
    #[storage]
    struct Storage {}
}
```

> **Note:** You'll be working on the `counter.cairo` file to complete the requirements of each step. The file `prev_solution.cairo` will show up in future steps as a way to catch up with the workshop if you fall behind. **Don't modify that file**.

## Step 1

Checkout the step1 branch to enable the verification tests for this section.

```bash
$ git checkout -b step1 origin/step1
```

### Goal

The goal is to create a contract that has the following:

1. a constructor function that received and stores a value of `u32` type to the a variable called `counter` from the storage
2. a public function called `get_counter()` that has read-access and returns the value from the storage
3. a public function called `increase_counter()` that has write-access that incremenets the value from the storage by `1`.

### Verification

When completed, execute the test suite to verify you've met all the requirements for this section.

```bash
$ snforge test
```

## Step 1

add owner to constructor/storage

### Goal

### Requirements

### Verification

### Hints

## Step 2

assert_only_owner

### Goal

### Requirements

### Verification

### Hints

## Step 3

transfer_ownership

### Goal

### Requirements

### Verification

### Hints

## Step 4

create owner

### Goal

### Requirements

### Verification

### Hints

## Step 5

create transfer ownership

### Goal

### Requirements

### Verification

### Hints

## Step 6

create renounce ownership

### Goal

### Requirements

### Verification

### Hints

## Step 7

finally, private function, create initializer and change the constructor

### Goal

### Requirements

### Verification

### Hints

## Step 8

events

### Goal

### Requirements

### Verification

### Hints

## Step 9

Component as Ownable

1. create a new file called ownable.cairo and move all the ownable code there

### Goal

### Requirements

### Verification

### Hints

## Step 10

adapt the code to a component

### Goal

### Requirements

### Verification

### Hints

## Step 11

implement the component in the main counter file
OZ Ownable

### Goal

### Requirements

### Verification

### Hints

## Step 11

1. add OZ as dependecies / replace your component imports with OZ
2. remove ownable.cairo file (edited)

### Goal

### Requirements

### Verification

### Hints
