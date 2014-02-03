# testfast

A lightweight testing framework for Julia. Recursively finds your Julia test files and runs them, with some helpful setup/teardown functionality to DRY up your tests a little bit.

## Installation

Install testfast from your Julia repl:

```julia
Pkg.clone("git://github.com/Veraticus/testfast.jl.git")
```

Then create the `testfast.jl` file in your `test/` directory. (This is your test helper -- it'll start the tests and you can put global setup/teardown istuff in it.) It doesn't need any more content than this:

```julia
using Testfast

Testfast.run!()
```

## Usage

### A Test File

A testfast test file's name must end with `test` and have the `.jl` extension -- otherwise it won't be run by testfast. It should ideally contain a bunch of tests, defined using the `@test` macro:

```julia
@test "this is the name of the test" begin
  @assert 1 == 1
end
```

You can also define `@before_all`, `@setup`, `@teardown` and/or `@after_all` if you need to perform some common setup or cleanup for all your tests.

### @before_all

Run only once for each test file, before all tests are run.

### @setup

Run before each test in the test file.

### @teardown

Run after each test in the test file.

### @after_all

Run only once for each test file, after all tests are run.

## Running

Once you've authored your tests, run them:

```
$ julia test/testfast.jl
..........

10 tests run.
10 passed, 0 failed in 0.0189 seconds.
```
