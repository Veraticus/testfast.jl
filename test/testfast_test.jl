@test "add_test_files skips . and .." quote
  @assert !in(".", Testfast.files)
  @assert !in("..", Testfast.files)
end

@test "add_test_files scans through all directories and adds all files" quote
  @assert in("./folder/nested_folder/testfast_nested_folder_test.jl", Testfast.files)
  @assert in("./folder/testfast_folder_test.jl", Testfast.files)
  @assert in("./testfast_test.jl", Testfast.files)
end

@test "before_all is added properly" quote
  @assert before_all_test == 1
end

@test "setup is added properly" quote
  @assert setup_test == 4 # This is the fourth run test
end

@test "teardown is added properly" quote
  @assert teardown_test == 4 # This is the fifth test, so teardowns have run four times
end
