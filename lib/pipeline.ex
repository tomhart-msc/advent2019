defmodule Pipeline do
  def find_best(tokens, inputs) do
    perms = permutations(inputs)
    Enum.map(perms, fn p -> pipeline(tokens, p) end) |> Enum.max()
  end

  def pipeline(tokens, lst), do: pipeline(tokens, lst, 0)
  def pipeline(_tokens, [], output) do
    #IO.puts("CANDIDATE IS #{output}")
    output
  end
  def pipeline(tokens, [input | rest], output) do
    IoAgent.set([input, Integer.to_string(output)])
    Opcode.run_program(tokens)
    new_output = OutputAgent.get()
    pipeline(tokens, rest, new_output)
  end

  # https://elixirforum.com/t/most-elegant-way-to-generate-all-permutations/2706/2
  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

end
