defmodule Passwords do

  def non_decreasing(str) do
    r = 0..(String.length(str) - 2)
    Enum.all?(r, fn i -> String.at(str, i) <= String.at(str, i+1) end)
  end

  def has_repeating_digit(str) do
    r = 0..(String.length(str) - 2)
    Enum.any?(r, fn i -> String.at(str, i) == String.at(str, i+1) end)
  end

  def has_repetition_of_length_exactly_two(str) do
    r = 0..(String.length(str) - 2)
    Enum.any?(r, fn i -> repetition_of_length_two(str, i) end)
  end

  defp repetition_of_length_two(str, i), do: repetition_of_length_two(str, i, String.length(str))

  defp repetition_of_length_two(str, i, len) do
    c0 = char(str, i-1, len)
    c1 = char(str, i, len)
    c2 = char(str, i+1, len)
    c3 = char(str, i+2, len)
    c0 != c1 and c1 == c2 and c2 != c3
  end

  defp char(_, i, _) when i < 0, do: "X"
  defp char(_, i, len) when i >= len, do: "X"
  defp char(s, i, _), do: String.at(s, i)

end
