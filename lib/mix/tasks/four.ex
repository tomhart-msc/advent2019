defmodule Mix.Tasks.Four do
  use Mix.Task

  def run(_) do
    lower = String.to_integer(Enum.at(System.argv(), 1))
    upper = String.to_integer(Enum.at(System.argv(), 2))

    IO.puts(part1(lower, upper))
    IO.puts(part2(lower, upper))
  end

  def part1(lower, upper) do
    r = lower..upper
    Enum.count(r, &satisfies_part1/1)
  end

  def satisfies_part1(n) do
    s = Integer.to_string(n)
    Passwords.non_decreasing(s) and Passwords.has_repeating_digit(s)
  end

  def part2(lower, upper) do
    r = lower..upper
    Enum.count(r, &satisfies_part2/1)
  end

  def satisfies_part2(n) do
    s = Integer.to_string(n)
    Passwords.non_decreasing(s) and Passwords.has_repetition_of_length_exactly_two(s)
  end
end
