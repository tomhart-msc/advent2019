defmodule Opcode do
  @operators %{1 => &+/2, 2 => &*/2, 99 => :halt}

  def apply_op(tokens, index) do
    apply_op(tokens, index, Map.fetch!(@operators, Enum.fetch!(tokens, index)))
  end

  def apply_op(tokens, _, :halt), do: tokens

  def apply_op(tokens, index, operator) do
    #IO.puts(Enum.join(tokens, ","))
    index1 = Enum.fetch!(tokens, index + 1)
    index2 = Enum.fetch!(tokens, index + 2)
    index3 = Enum.fetch!(tokens, index + 3)

    operand1 = Enum.fetch!(tokens, index1)
    operand2 = Enum.fetch!(tokens, index2)
    result = operator.(operand1, operand2)
    apply_op(List.replace_at(tokens, index3, result), index + 4)
  end
end
