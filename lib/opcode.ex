defmodule Opcode do
  @operators %{1 => &+/2, 2 => &*/2, 7 => &Opcode.lessOp/2, 8 => &Opcode.equalsOp/2, 99 => :halt}
  @arities %{1 => 2, 2 => 2, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 2, 8 => 2, 99 => 0}

  def parse_program(s), do: String.split(s, ",")

  def run_program(list) do
    processed = new_apply_op(list, 0)
    String.to_integer(Enum.at(processed, 0))
  end

  def apply_op(tokens, index) do
    apply_op(tokens, index, Map.fetch!(@operators, Enum.fetch!(tokens, index)))
  end

  def new_apply_op(tokens, index) do
    {opcode, modes} = parse_opcode(Enum.fetch!(tokens, index))
    apply_op(tokens, index, opcode, modes)
  end

  defp apply_op(tokens, index, 1, modes), do: apply_binary_op(tokens, index, 1, modes)
  defp apply_op(tokens, index, 2, modes), do: apply_binary_op(tokens, index, 2, modes)

  defp apply_op(tokens, index, 3, _) do
    input = IO.gets("Enter a number: ")
    result = String.trim(input)
    result_index = String.to_integer(Enum.fetch!(tokens, index + 1))
    #IO.puts("<< Storing #{result} to index #{result_index}")
    new_apply_op(List.replace_at(tokens, result_index, result), index + 2)
  end

  defp apply_op(tokens, index, 4, _) do
    result_index = Enum.fetch!(tokens, index + 1)
    output = Enum.fetch!(tokens, String.to_integer(result_index))
    IO.puts(">> #{output}")
    new_apply_op(tokens, index + 2)
  end

  defp apply_op(tokens, index, 5, modes) do
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    new_index = jump_if(operand1, true, operand2, index)
    #IO.puts("Applying op 5 to #{operand1} #{operand2}, next index is #{new_index}")
    new_apply_op(tokens, new_index)
  end

  defp apply_op(tokens, index, 6, modes) do
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    new_apply_op(tokens, jump_if(operand1, false, operand2, index))
  end

  defp apply_op(tokens, index, 7, modes), do: apply_binary_op(tokens, index, 7, modes)
  defp apply_op(tokens, index, 8, modes), do: apply_binary_op(tokens, index, 8, modes)

  defp apply_op(tokens, _, 99, _), do: tokens

  defp jump_if(a, b, jmp, _) when (a != 0) == b, do: jmp
  defp jump_if(_, _, _, index), do: index + 3

  def equalsOp(a, b) when a == b, do: 1
  def equalsOp(_, _), do: 0

  def lessOp(a, b) when a < b, do: 1
  def lessOp(_, _), do: 0

  defp apply_binary_op(tokens, index, opcode, modes) do
    #IO.puts("Applying op #{opcode} at index #{index}")
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    result_index = String.to_integer(Enum.fetch!(tokens, index + 3))
    operator = operator(opcode)
    result = Integer.to_string(operator.(operand1, operand2))
    #IO.puts("Storing #{result} at index #{result_index}")
    new_apply_op(List.replace_at(tokens, result_index, result), index + 4)
  end

  defp argument(tokens, index, arg_num, 0) do
    x = String.to_integer(Enum.fetch!(tokens, index + arg_num + 1))
    String.to_integer(Enum.fetch!(tokens, x))
  end
  defp argument(tokens, index, arg_num, 1) do
    String.to_integer(Enum.fetch!(tokens, index + arg_num + 1))
  end
  defp argument(tokens, index, arg_num, modes) when is_binary(modes) do
    mode = operand_mode(modes, arg_num)
    argument(tokens, index, arg_num, mode)
  end

  # Gets the opcode as an integer, and a string representing the modes of its operands
  def parse_opcode(op), do: do_parse_opcode(String.reverse(op))
  defp do_parse_opcode(<<_>> = op), do: {String.to_integer(op), ""}
  defp do_parse_opcode(<<_, _>> = op), do: {String.to_integer(op), ""}
  defp do_parse_opcode(<<e, d, cba :: binary>>), do: {String.to_integer(<<d, e>>), cba}

  # Gets the arity of a given opcode
  def arity(opcode), do: Map.fetch!(@arities, opcode)

  def operator(opcode), do: Map.fetch!(@operators, opcode)

  # Given an operand string and an operand index, gets the mode of the operand, defaulting to 0
  def operand_mode(cba, i), do: operand_mode(cba, String.length(cba), i)
  defp operand_mode(_, len, i) when i >= len, do: 0
  defp operand_mode(cba, _, i), do: String.to_integer(String.at(cba, i))


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
