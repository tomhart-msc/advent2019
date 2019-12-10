defmodule ResultCollector do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def store(pid, result) do
    Agent.update(__MODULE__, &Map.put(&1, pid, result))
  end

  def get(pid) do
    Agent.get(__MODULE__, &Map.get(&1, pid, :unknown))
  end
end
