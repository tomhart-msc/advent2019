defmodule Tree do
  def from_lines(lines) do
    segments = lines |> Enum.map(&Tree.to_segment/1)
    build_tree("COM", segments)
  end

  def to_segment(line) do
    [a, b] = String.split(String.trim(line), ")")
    {a, b}
  end

  def child_segments(symbol, segments) do
    Enum.filter(segments, fn {a, _} -> a == symbol end)
  end

  def child_symbols(symbol, segments) do
    child_segments(symbol, segments) |> Enum.map(fn {_, b} -> b end)
  end

  def build_tree(root_symbol, segments) do
    children = child_symbols(root_symbol, segments)
    node = %{root_symbol => children}
    child_trees = children |> Enum.map(fn child -> build_tree(child, segments) end)
    Enum.reduce(child_trees, node, fn x, acc -> Map.merge(acc, x) end)
  end

  def orbits(tree, root) do
    orbits(tree, root, -1)
  end

  def orbits(tree, root, parent_orbits) do
    my_orbits = parent_orbits + 1
    Enum.reduce(children(tree, root), my_orbits, fn x, acc -> orbits(tree, x, my_orbits) + acc end)
  end

  def children(tree, root) do
    Map.fetch!(tree, root)
  end

  # Gets the symbol which is the closest ancestor of symbols "san" and "you"
  def gcd(tree, root, san, you) do
    kids = children(tree, root)
    ancestor = Enum.find(kids, root, fn kid -> is_ancestor(tree, kid, san) and is_ancestor(tree, kid, you) end)
    # If the ancestor is me, it's the GCD.
    gcd_helper(tree, root, ancestor, san, you)
  end

  defp gcd_helper(_, me, me, _, _), do: me
  defp gcd_helper(tree, _, kid, san, you), do: gcd(tree, kid, san, you)

  def is_ancestor(tree, root, child) do
    kids = children(tree, root)
    Enum.any?(kids, fn kid -> kid == child end) or Enum.any?(kids, fn kid -> is_ancestor(tree, kid, child) end)
  end

  def distance(tree, root, child) do
    kids = children(tree, root)
    ancestor = Enum.find(kids, root, fn kid -> is_ancestor(tree, kid, child) end)
    distance_helper(tree, root, ancestor, child)
  end

  defp distance_helper(_, me, me, _), do: 1
  defp distance_helper(tree, _, child, descendant), do: 1 + distance(tree, child, descendant)
end
