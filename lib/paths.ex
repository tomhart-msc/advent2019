defmodule Paths do
  @direction_vectors %{"U" => {0,1}, "D" => {0,-1}, "L" => {-1,0}, "R" => {1,0}}
  @origin {0, 0}

  def min_cross(path1, path2) do
    list1 = coordinate_list(path1)
    list2 = coordinate_list(path2)
    common_points = intersect(list1, list2) -- [@origin]
    Enum.min(Enum.map(common_points, &manhattan_distance/1))
  end

  def min_cross_by_wire(path1, path2) do
    list1 = coordinate_list(path1)
    list2 = coordinate_list(path2)
    common_points = intersect(list1, list2) -- [@origin]
    Enum.min(Enum.map(common_points, fn p -> wire_distance(p, list1) + wire_distance(p, list2) end))
  end

  def coordinate_list(input) do
    vectors = String.split(input, ",") |> Enum.map(&vectorize/1)
    visited([@origin], vectors)
  end

  # Transform a set of direction vectors to the list of all points visited along the path
  def visited(list, []), do: list
  def visited(list, [@origin | rest]), do: visited(list, rest)
  def visited(list = [{a,b} | _], [{0,y} | rest]) when y > 0, do: visited([{a, b + 1} | list], [{0,y-1} | rest])
  def visited(list = [{a,b} | _], [{0,y} | rest]) when y < 0, do: visited([{a, b - 1} | list], [{0,y+1} | rest])
  def visited(list = [{a,b} | _], [{x,0} | rest]) when x > 0, do: visited([{a + 1, b} | list], [{x-1,0} | rest])
  def visited(list = [{a,b} | _], [{x,0} | rest]) when x < 0, do: visited([{a - 1, b} | list], [{x+1,0} | rest])

  def vectorize(s) do
    [direction, amount_string] = Regex.run(~r/([UDLR])(\d+)/, s, capture: :all_but_first)
    amount = String.to_integer(amount_string)
    {x, y} = Map.fetch!(@direction_vectors, direction)
    {x * amount, y * amount}
  end

  # Gets the intersection of two sets of coordinates. This is *MUCH* faster than using -- twice.
  def intersect(p1, p2) do
    Enum.to_list(MapSet.intersection(Enum.into(p1, MapSet.new), Enum.into(p2, MapSet.new)))
  end

  # Return the Manhattan distance from {0, 0} to this point
  def manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  # Return the number of steps along "path" to reach the point (x,y)
  def wire_distance({x,y}, path) do
    wire_distance({x,y}, Enum.reverse(path), 0)
  end
  def wire_distance({x,y}, [{a,b} | _], acc) when x == a and y == b, do: acc
  def wire_distance({x,y}, [_ | rest], acc), do: wire_distance({x,y}, rest, acc + 1)
end
