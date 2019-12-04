defmodule Mix.Tasks.Three do
  use Mix.Task

  def run(_) do
    filename = Enum.at(System.argv(), 1)
    process_file(filename)
    #part_two(File.read(filename))
  end

  def process_file(s) do
    #IO.puts("Processing " <> s)
    [line1, line2] = Enum.to_list(File.stream!(s))
    #IO.puts("line 1 " <> line1)
    #IO.puts("line 2 " <> line2)
    IO.puts(Paths.min_cross(line1, line2))
    IO.puts(Paths.min_cross_by_wire(line1, line2))
  end
end
