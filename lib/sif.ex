defmodule SIF do
  @black "0"
  @white "1"
  @transparent "2"

  def layers(s, width, height) do
    s |> String.to_charlist() |> Enum.chunk_every(width * height) |> Enum.map(&List.to_string/1)
  end

  def num_char(s, char) do
    s |> String.to_charlist() |> Enum.count(fn c -> c == char end)
  end

  def stack(layers) do
    rev = Enum.reverse(layers)
    Enum.reduce(rev, Enum.fetch!(layers, 0), fn layer, acc -> stack(acc, layer) end)
  end

  def render(s, width) do
    render(s, String.length(s), 0, width)
  end
  defp render(_, len, start, _) when start >= len, do: nil
  defp render(s, len, start, width) do
    IO.puts(String.slice(s, start, width) |> String.replace(@black, "#") |> String.replace(@white, " "))
    render(s, len, start + width, width)
  end

  defp stack(bottom, top) do
    #IO.puts("Stacking layers: ")
    #IO.puts("  bottom: #{bottom}")
    #IO.puts("     top: #{top}")
    range = 0..(String.length(bottom) - 1)
    Enum.map(range, fn i -> combine(String.at(bottom, i), String.at(top, i)) end) |> Enum.join("")
  end

  defp combine(_, @black), do: @black
  defp combine(_, @white), do: @white
  defp combine(x, @transparent), do: x
end
