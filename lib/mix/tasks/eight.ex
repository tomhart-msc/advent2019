defmodule Mix.Tasks.Eight do
  use Mix.Task

  def run(_) do
    filename = Enum.at(System.argv(), 1)
    IO.puts(part_one(File.read(filename)))
    IO.puts(part_two(File.read(filename)))
  end

  def part_one({:ok, s}) do
    layers = SIF.layers(s, 25, 6)
    most_zeroes = Enum.min_by(layers, fn layer -> SIF.num_char(layer, ?0) end)
    SIF.num_char(most_zeroes, ?1) * SIF.num_char(most_zeroes, ?2)
  end

  def part_two({:ok, s}) do
    layers = SIF.layers(s, 25, 6)
    #IO.inspect(layers)
    image = SIF.stack(layers)
    SIF.render(image, 25)
  end

end
