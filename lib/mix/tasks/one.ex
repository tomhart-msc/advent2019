defmodule Mix.Tasks.One do
  use Mix.Task

  # Part 1: 3358992
  def run(_) do
    filename = Enum.at(System.argv(), 1)
    IO.puts(process_file(filename))
  end

  def process_file(nil) do
    IO.puts("Must specify a file name")
  end

  def process_file(s) do
    #IO.puts("Processing " <> s)
    stream = File.stream!(s)
    stream |> Enum.map(&String.trim/1) |> Enum.map(&process_line_with_fuel/1) |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def process_line(line) do
    #IO.puts("processing line " <> line)
    process_number(Integer.parse(line))
  end

  def process_number(:error) do
    #IO.puts("BAD INPUT")
    0
  end

  def process_number({n, _}) do
    fuel_required(n)
  end

  def process_line_with_fuel(line) do
    process_with_fuel(Integer.parse(line))
  end

  def process_with_fuel(:error), do: 0

  def process_with_fuel({n, _}), do: process_with_fuel(n)

  def process_with_fuel(mass) do
    fuel = fuel_required(mass)
    fuel + fuel_fuel(fuel)
  end

  def fuel_required(n) do
    div(n, 3) - 2
  end

  def fuel_fuel(n) when n > 5 do
    additional_fuel = fuel_required(n)
    additional_fuel + fuel_fuel(additional_fuel)
  end

  def fuel_fuel(_) do
    0
  end
end
