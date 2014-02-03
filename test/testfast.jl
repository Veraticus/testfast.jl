using Testfast

# Run once before all tests
@before_all begin
  before_all_test = 0
  setup_test = 0
  teardown_test = 0
  after_all_test = 0

  before_all_test += 1
end

# Run before each test
@setup begin
  setup_test += 1
end

# Run after each test
@teardown begin
  teardown_test += 1
end

# Run once after all tests
@after_all begin
  after_all_test += 1
end

Testfast.run!()
