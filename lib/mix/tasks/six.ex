defmodule Mix.Tasks.Six do
  use Mix.Task

  def run(_) do
    filename = Enum.at(System.argv(), 1)
    #part_one(filename)
    part_two(filename)
  end

  def part_one(s) do
    lines = Enum.to_list(File.stream!(s))
    tree = Tree.from_lines(lines)
    IO.puts(Tree.orbits(tree, "COM"))
  end

  def part_two(s) do
    lines = Enum.to_list(File.stream!(s))
    tree = Tree.from_lines(lines)
    gcd = Tree.gcd(tree, "COM", "SAN", "YOU")
    hops = Tree.distance(tree, gcd, "SAN") + Tree.distance(tree, gcd, "YOU") - 2
    IO.puts(">>> #{hops} orbital hops between SAN and YOU via GCD #{gcd}")
  end
end
