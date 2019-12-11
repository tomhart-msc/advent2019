defmodule AdventTest do
  use ExUnit.Case
  doctest Advent

  test "day2 part one" do
    input = "1,9,10,3,2,3,11,0,99,30,40,50"
    result = Mix.Tasks.Two.process(input)
    assert 3500 == result
  end

  test "vectorize a direction" do
    {x, y} = Paths.vectorize("R83")
    assert 83 == x
    assert 0 == y

    {a, b} = Paths.vectorize("D2")
    assert 0 == a
    assert -2 == b
  end

  test "manhattan distance" do
    assert 10 == Paths.manhattan_distance({5, 5})
    assert 7 == Paths.manhattan_distance({3, -4})
  end

  test "get visited coordinates" do
    points = Paths.visited([{0,0}], [{0, 1}, {2, 0}, {0, -3}, {-3,0}])
    expected = [{-1,-2}, {0,-2}, {1,-2}, {2,-2}, {2, -1}, {2,0}, {2,1}, {1,1}, {0,1}, {0,0}]
    assert expected == points
  end

  test "I can get the intersection of two paths" do
    p1 = [{0,0}, {0,1}, {1,1}, {1,2}]
    p2 = [{0,0}, {1,0}, {1,1}, {2,1}]
    assert [{0, 0}, {1,1}] == Paths.intersect(p1, p2)
  end

  test "transform directions to a list of visited coordinates and get the closest cross to the origin" do
    p1 = "R8,U5,L5,D3"
    p2 = "U7,R6,D4,L4"
    assert 6 == Paths.min_cross(p1, p2)
  end

  test "minimum cross, test case 2" do
    p1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    p2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    assert 159 == Paths.min_cross(p1, p2)
  end

  test "transform directions to a list of visited coordinates and get the closest cross to the origin by wire distance" do
    p1 = "R8,U5,L5,D3"
    p2 = "U7,R6,D4,L4"
    assert 30 == Paths.min_cross_by_wire(p1, p2)
  end

  test "minimum by wire distance, test case 2" do
    p1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    p2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    assert 610 == Paths.min_cross_by_wire(p1, p2)
  end

  test "check if a string is non-decreasing" do
    assert Passwords.non_decreasing("122345")
    assert not Passwords.non_decreasing("122343")
  end

  test "check if a string has repeating digits" do
    assert Passwords.has_repeating_digit("111111")
    assert not Passwords.has_repeating_digit("123456")
  end

  test "check for repetitions of length exactly two" do
    assert not Passwords.has_repetition_of_length_exactly_two("123456")
    assert Passwords.has_repetition_of_length_exactly_two("112233")
    assert not Passwords.has_repetition_of_length_exactly_two("444123")
    assert not Passwords.has_repetition_of_length_exactly_two("123444")
    assert Passwords.has_repetition_of_length_exactly_two("111122")
  end

  test "opcode and mode parsing" do
    input = 1002
    {opcode, modes} = Opcode.parse_opcode(input)
    assert 2 == opcode
    assert 2 == Opcode.arity(opcode)
    assert 0 == Opcode.operand_mode(modes, 0)
    assert 1 == Opcode.operand_mode(modes, 1)
    assert 0 == Opcode.operand_mode(modes, 2)
  end

  test "pipeline optimization" do
    {:ok, pid} = IoAgent.start_link("Hi")
    {:ok, pid2} = OutputAgent.start_link("Hi")
    s = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
    best = Pipeline.find_best(Opcode.parse_program(s), ["0", "1", "2", "3", "4"])
    assert best == 43210
    Agent.stop(pid2)
    Agent.stop(pid)
  end

  test "stacking SIF images" do
    s = "0222112222120000"
    layers = SIF.layers(s, 2, 2)
    assert "0110" == SIF.stack(layers)
  end

end
