defmodule Feedback do
  def find_best(tokens, inputs) do
    {:ok, pid} = ResultCollector.start_link(nil)
    perms = permutations(inputs)
    result = Enum.map(perms, fn p -> pipeline(tokens, p) end) |> Enum.max()
    Agent.stop(pid)
    result
  end

  def pipeline(tokens, inputs) do
    start_workers(tokens, inputs, length(inputs), 0)
    last = int_to_atom(length(inputs) - 1)
    send int_to_atom(0), 0
    await_termination(last)
    ResultCollector.get(last)
  end

  defp await_termination(pid) do
    #IO.puts("Awaiting termination of #{pid}")
    ref = Process.monitor(pid)
    receive do
      {:DOWN, ^ref, _, _, _} -> nil #IO.puts("#{pid} terminated")
    end
  end

  defp start_workers(_, [], _, _), do: nil
  defp start_workers(tokens, [input | rest], num_workers, i) do
    name = int_to_atom(i)
    stdout = int_to_atom(rem(i + 1, num_workers))
    pid = spawn(fn -> IntCode.run_program(tokens, name, stdout, self()) end)
    Process.register(pid, name)
    send pid, input
    start_workers(tokens, rest, num_workers, i + 1)
  end

  # https://elixirforum.com/t/most-elegant-way-to-generate-all-permutations/2706/2
  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

  def int_to_atom(i), do: i |> Integer.to_string() |> String.to_atom()
end
