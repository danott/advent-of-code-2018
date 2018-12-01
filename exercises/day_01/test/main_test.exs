# https://adventofcode.com/2018/day/1

defmodule FrequencyFixerUpper do
  def parse_instructions(string) do
    strings = String.split(string, ", ")
    Enum.map(strings, fn f -> String.to_integer(f) end)
  end

  def execute_instructions(string) do
    instructions = parse_instructions(string)
    Enum.reduce(instructions, 0, fn i, a -> i + a end)
  end

  def find_first_duplicate(string) do
    instructions = parse_instructions(string)
    _recursive_find_first_duplicate(instructions, {0, [0]})
  end

  def _recursive_find_first_duplicate(_instructions, accumulator) when is_integer(accumulator) do
    accumulator
  end

  def _recursive_find_first_duplicate(instructions, accumulator) when is_tuple(accumulator) do
    result =
      Enum.reduce_while(instructions, accumulator, fn i, {a, s} ->
        if Enum.member?(s, i + a), do: {:halt, i + a}, else: {:cont, {i + a, s ++ [i + a]}}
      end)

    _recursive_find_first_duplicate(instructions, result)
  end
end

defmodule FrequencyFixerUpperTest do
  use ExUnit.Case

  test "parsing instructions" do
    assert FrequencyFixerUpper.parse_instructions("-1, 2, 3") == [-1, 2, 3]
  end

  test "example instructions" do
    assert FrequencyFixerUpper.execute_instructions("+1, +1, +1") == 3
    assert FrequencyFixerUpper.execute_instructions("+1, +1, -2") == 0
    assert FrequencyFixerUpper.execute_instructions("-1, -2, -3") == -6
  end

  test "find solution to part 1" do
    input = File.read!("./input.txt")
    input = String.trim(input)
    input = String.replace(input, "\n", ", ")
    assert FrequencyFixerUpper.execute_instructions(input) == 0
  end

  test "finding a dupe" do
    assert FrequencyFixerUpper.find_first_duplicate("-1, +1") == 0
    assert FrequencyFixerUpper.find_first_duplicate("+3, +3, +4, -2, -4") == 10
    assert FrequencyFixerUpper.find_first_duplicate("-6, +3, +8, +5, -6") == 5
    assert FrequencyFixerUpper.find_first_duplicate("+7, +7, -2, -7, -4") == 14
  end

  test "find solution to part 2" do
    input = File.read!("./input.txt")
    input = String.trim(input)
    input = String.replace(input, "\n", ", ")
    assert FrequencyFixerUpper.find_first_duplicate(input) == 0
  end
end
