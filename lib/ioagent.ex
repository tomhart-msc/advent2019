defmodule IoAgent do
  #use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get() do
    lst = Agent.get(__MODULE__, &Map.get(&1, :inputs)) || []
    {input, new_list} = input_from_list(lst)
    set(new_list)
    input
  end

  def set(lst) do
    Agent.update(__MODULE__, &Map.put(&1, :inputs, lst))
  end

  defp input_from_list([]), do: {IO.gets("<< "), []}
  defp input_from_list([input | rest]), do: {input, rest}
end
