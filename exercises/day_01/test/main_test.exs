# https://adventofcode.com/2018/day/1

defmodule FrequencyFixerUpper do
  def parse_instructions(string) do
    String.split(string, ", ") |> Enum.map(&String.to_integer/1)
  end

  def execute_instructions(string) do
    parse_instructions(string) |> Enum.sum
  end

  def find_first_duplicate(string) do
    history = [0]
    instructions = parse_instructions(string)
    find_first_duplicate(history, instructions)
  end

  defp find_first_duplicate(history, instructions) when is_list(history) do
    Enum.reduce_while(instructions, history, &history_or_first_duplicate/2)
      |> find_first_duplicate(instructions)
  end

  defp find_first_duplicate(total, _) when is_integer(total) do
    total
  end

  defp history_or_first_duplicate(integer, history) do
    total = List.first(history) + integer
    if Enum.member?(history, total) do
      {:halt, total}
    else
      {:cont, [total] ++ history}
    end
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
    input = File.read!("./input.txt") |> String.trim |> String.replace("\n", ", ")
    assert FrequencyFixerUpper.execute_instructions(input) == 553
  end

  test "finding a dupe" do
    assert FrequencyFixerUpper.find_first_duplicate("-1, +1") == 0
    assert FrequencyFixerUpper.find_first_duplicate("+3, +3, +4, -2, -4") == 10
    assert FrequencyFixerUpper.find_first_duplicate("-6, +3, +8, +5, -6") == 5
    assert FrequencyFixerUpper.find_first_duplicate("+7, +7, -2, -7, -4") == 14
  end

  test "find solution to part 2" do
    input = File.read!("./input.txt") |> String.trim |> String.replace("\n", ", ")
    assert FrequencyFixerUpper.find_first_duplicate(input) == 78724
  end
end
