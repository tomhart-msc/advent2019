defmodule IntCode do
  @moduledoc """
  This module defines an IntCode computer which runs as an independent process.
  """

  @operators %{1 => &+/2, 2 => &*/2, 7 => &Opcode.lessOp/2, 8 => &Opcode.equalsOp/2, 99 => :halt}
  @arities %{1 => 2, 2 => 2, 3 => 1, 4 => 1, 5 => 2, 6 => 2, 7 => 2, 8 => 2, 99 => 0}

  def parse_program(s), do: String.split(s, ",") |> Enum.map(&String.to_integer/1)

  def run_program(list, name, stdout, parent) do
    #IO.puts("Started with stdout #{stdout}")
    processed = apply_op(list, 0, {name, stdout, parent})
    Enum.at(processed, 0)
    #IO.puts("HALTING process that sends to #{stdout}!")
    #send parent, :done
  end

  defp apply_op(tokens, index, stdout) do
    {opcode, modes} = parse_opcode(Enum.fetch!(tokens, index))
    apply_op(tokens, index, opcode, modes, stdout)
  end

  defp apply_op(tokens, index, 1, modes, stdout), do: apply_binary_op(tokens, index, 1, modes, stdout)
  defp apply_op(tokens, index, 2, modes, stdout), do: apply_binary_op(tokens, index, 2, modes, stdout)

  defp apply_op(tokens, index, 3, _, stdout) do
    #IO.puts("3: stdout #{stdout}")
    input = get_data()
    result_index = Enum.fetch!(tokens, index + 1)
    #IO.puts("<< Storing #{input} to index #{result_index}")
    apply_op(List.replace_at(tokens, result_index, input), index + 2, stdout)
  end

  defp apply_op(tokens, index, 4, _, stdout) do
    #IO.puts("4: stdout #{stdout}")
    result_index = Enum.fetch!(tokens, index + 1)
    output = Enum.fetch!(tokens, result_index)
    put_data(output, stdout)
    apply_op(tokens, index + 2, stdout)
  end

  defp apply_op(tokens, index, 5, modes, stdout) do
    #IO.puts("5: stdout #{stdout}")
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    new_index = jump_if(operand1, true, operand2, index)
    apply_op(tokens, new_index, stdout)
  end

  defp apply_op(tokens, index, 6, modes, stdout) do
    #IO.puts("6: stdout #{stdout}")
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    apply_op(tokens, jump_if(operand1, false, operand2, index), stdout)
  end

  defp apply_op(tokens, index, 7, modes, stdout), do: apply_binary_op(tokens, index, 7, modes, stdout)
  defp apply_op(tokens, index, 8, modes, stdout), do: apply_binary_op(tokens, index, 8, modes, stdout)

  defp apply_op(tokens, _, 99, _, _), do: tokens

  defp jump_if(a, b, jmp, _) when (a != 0) == b, do: jmp
  defp jump_if(_, _, _, index), do: index + 3

  def equalsOp(a, b) when a == b, do: 1
  def equalsOp(_, _), do: 0

  def lessOp(a, b) when a < b, do: 1
  def lessOp(_, _), do: 0

  defp apply_binary_op(tokens, index, opcode, modes, stdout) do
    #IO.puts("Applying op #{opcode} at index #{index}")
    operand1 = argument(tokens, index, 0, modes)
    operand2 = argument(tokens, index, 1, modes)
    result_index = Enum.fetch!(tokens, index + 3)
    operator = operator(opcode)
    result = operator.(operand1, operand2)
    #IO.puts("Storing #{result} at index #{result_index}")
    apply_op(List.replace_at(tokens, result_index, result), index + 4, stdout)
  end

  defp argument(tokens, index, arg_num, 0) do
    x = Enum.fetch!(tokens, index + arg_num + 1)
    Enum.fetch!(tokens, x)
  end
  defp argument(tokens, index, arg_num, 1) do
    Enum.fetch!(tokens, index + arg_num + 1)
  end
  defp argument(tokens, index, arg_num, modes) when is_binary(modes) do
    mode = operand_mode(modes, arg_num)
    argument(tokens, index, arg_num, mode)
  end

  # Gets the opcode as an integer, and a string representing the modes of its operands
  def parse_opcode(op), do: do_parse_opcode(String.reverse(Integer.to_string(op)))
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

  defp get_data do
    msg = _get_data()
    #IO.puts("<<< Received #{msg}")
    msg
  end

  defp _get_data do
    receive do
      msg -> msg
    end
  end

  defp put_data(output, {name, stdout, parent}) do
    #IO.puts(">>> Sending #{output} to #{stdout}")
    ResultCollector.store(name, output)
    try do
      send stdout, output
    rescue
      _ in ArgumentError -> send parent, output
    end
  end
end
