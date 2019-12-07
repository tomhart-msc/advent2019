defmodule Mix.Tasks.Seven do
  use Mix.Task

  def run(_) do
    {:ok, pid} = IoAgent.start_link("Hi")
    {:ok, pid2} = OutputAgent.start_link("Hi")
    filename = Enum.at(System.argv(), 1)
    IO.puts(part_one(File.read(filename)))
    #part_two(filename)
    Agent.stop(pid2)
    Agent.stop(pid)
  end

  def part_one({:ok, s}) do
    Pipeline.find_best(Opcode.parse_program(s), ["0", "1", "2", "3", "4"])
  end


end
