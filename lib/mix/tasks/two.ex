defmodule Mix.Tasks.Two do
  use Mix.Task

  def run(_) do
    filename = Enum.at(System.argv(), 1)
    process_file(File.read(filename))
    part_two(File.read(filename))
  end

  def process_file({:ok, s}), do: load_and_process(s)

  def process_file({:error, _}) do
    IO.puts("ERROR!")
  end

  def part_two({:ok, s}) do
    goal = 19690720
    tokens = String.split(s, ",") |> Enum.map(&String.to_integer/1)
    limit = length(tokens)
    found = search(tokens, goal, limit, 0, 0)
    show_solution(found)
  end

  def part_two({:error, _}) do
    IO.puts("ERROR!")
  end

  def show_solution({:not_found, :not_found}), do: IO.puts("No solution")
  def show_solution({noun, verb}), do: IO.puts("noun = #{noun}, verb = #{verb}")

  def search(tokens, goal, limit, x, y) when x >= limit, do: search(tokens, goal, limit, 0, y + 1)
  def search(_, _, limit, _, y) when y >= limit, do: {:not_found, :not_found}

  def search(tokens, goal, limit, x, y) do
    loaded = load_data(tokens, x, y)
    result = Enum.at(Opcode.apply_op(loaded, 0), 0)
    #IO.puts("Trying #{x}, #{y} -- #{result}")
    recurse(result, tokens, goal, limit, x, y)
  end

  def recurse(goal, _, goal, _, x, y), do: {x, y}
  def recurse(_, tokens, goal, limit, x, y), do: search(tokens, goal, limit, x + 1, y)

  def process(s) do
    tokens = String.split(s, ",") |> Enum.map(&String.to_integer/1)
    processed = Opcode.apply_op(tokens, 0)
    IO.puts(Enum.at(processed, 0))
    Enum.at(processed, 0)
  end

  def load_and_process(s) do
    tokens = String.split(s, ",") |> Enum.map(&String.to_integer/1)
    processed = Opcode.apply_op(load_data(tokens), 0)
    IO.puts(Enum.at(processed, 0))
    Enum.at(processed, 0)
  end

  def load_data(tokens) do
    x = List.replace_at(tokens, 1, 12)
    List.replace_at(x, 2, 2)
  end

  def load_data(tokens, noun, verb) do
    x = List.replace_at(tokens, 1, noun)
    List.replace_at(x, 2, verb)
  end

end
