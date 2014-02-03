@setup begin
  this_should_not_leak = true
end

@test "this file is loaded" begin
  @assert 1 == 1
end

@teardown begin
  this_also_should_not_leak = true
end