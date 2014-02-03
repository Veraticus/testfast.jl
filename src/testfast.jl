module Testfast

export @before_all,
       @setup,
       @teardown,
       @after_all,
       @test,
       run!

type Test
  name::String
  code::Expr
end

type Failure
  exception::ErrorException
  test::Test
end

global before_all = Expr[]
global setup = Expr[]
global teardown = Expr[]
global after_all = Expr[]
global files = String[]
global tests = Test[]
global failures = Failure[]
global total = 0

macro before_all(e::Expr)
  push!(before_all, e)
end

macro setup(e::Expr)
  push!(setup, e)
end

macro teardown(e::Expr)
  push!(teardown, e)
end

macro after_all(e::Expr)
  push!(after_all, e)
end

macro test(name::String, code::Expr)
  push!(tests, Test(name, code))
end

function add_test_files(directory = ".")
  for file in readdir(directory)
    file = "$directory/$file"
    if file == "." || file == ".."
      continue
    elseif oct(stat(file).mode)[1] == '4'
      add_test_files(file)
    elseif split(file, ".")[end-1][end-3:end] == "test"
      push!(files, file)
    end
  end
end

function run_tests()
  global before_all
  global setup
  global teardown
  global after_all
  global tests
  global failures
  global total
  global started

  for file in files
    _before_all = before_all
    _setup = setup
    _teardown = teardown
    _after_all = after_all

    tests = Test[]
    started = time()

    reload(file)

    for expr in before_all
      eval(:(esc($expr)))
    end

    for test in tests
      total += 1

      for expr in setup
        eval(:(esc($expr)))
      end

      try
        eval(eval(test.code))
        print_with_color(:green, ".")
      catch e
        print_with_color(:red, "F")
        push!(failures, Failure(e, test))
      end

      for expr in teardown
        eval(:(esc($expr)))
      end
    end

    for expr in after_all
      eval(:(esc($expr)))
    end

    before_all = _before_all
    setup = _setup
    teardown = _teardown
    after_all = _after_all
  end

end

function print_results()
  println("\n")

  println("$(total) tests run.\n$(total - length(failures)) passed, $(length(failures)) failed in $(round(time() - started, 4)) seconds.")

  if isempty(failures)
    exit(0)
  else
    println("Failures:")
    for failure in failures
      print("$(failure.test.name)\n\t$(failure.exception):\n\t")
      @show failure.test
      println("\n")
    end
    exit(1)
  end

end

function run!()
  # In case we're not in the test directory already...
  try
    cd("test")
  catch
    nothing # We are!
  end

  add_test_files()
  run_tests()
  print_results()
end

end
