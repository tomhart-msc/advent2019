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

end
