@test "add_test_files skips . and .." begin
  @assert !in(".", Testfast.files)
  @assert !in("..", Testfast.files)
end

@test "add_test_files scans through all directories and adds all files" begin
  @assert in("./folder/nested_folder/testfast_nested_folder_test.jl", Testfast.files)
  @assert in("./folder/testfast_folder_test.jl", Testfast.files)
  @assert in("./testfast_test.jl", Testfast.files)
end

@test "before_all is added properly" begin
  @assert before_all_test == 1
end

@test "setup is added properly" begin
  @assert setup_test == 4 # This is the fourth run test
end

@test "teardown is added properly" begin
  @assert teardown_test == 4 # This is the fifth test, so teardowns have run four times
end

@test "after_all is added properly" begin
  @assert after_all_test == 0 # This hasn't run at all yet
end

@test "no leaking from setups" begin
  error = false

  try
    this_should_not_leak == true
  catch
    error = true
  end

  @assert error

end

@test "no leaking from teardowns" begin
  error = false

  try
    this_also_should_not_leak == true
  catch
    error = true
  end

  @assert error

end