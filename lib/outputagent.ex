defmodule OutputAgent do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, &Map.get(&1, :output))
  end

  def set(x) do
    IO.puts(">> #{x}")
    Agent.update(__MODULE__, &Map.put(&1, :output, x))
  end
end
