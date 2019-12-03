defmodule AdventTest do
  use ExUnit.Case
  doctest Advent

  test "day2 part one" do
    input = "1,9,10,3,2,3,11,0,99,30,40,50"
    result = Mix.Tasks.Two.process(input)
    assert 3500 == result
  end
end
