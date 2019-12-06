defmodule Mix.Tasks.Five do
  use Mix.Task

  def run(_) do
    filename = Enum.at(System.argv(), 1)
    part_one(File.read(filename))
  end

  def part_one({:ok, s}) do
    tokens = Opcode.parse_program(s)
    Opcode.run_program(tokens)
  end

end
