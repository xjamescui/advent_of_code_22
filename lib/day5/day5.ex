defmodule Day5 do
  @input_path "lib/day5/day5.in"

  # [C]         [S] [H]
  # [F] [B]     [C] [S]     [W]
  # [B] [W]     [W] [M] [S] [B]
  # [L] [H] [G] [L] [P] [F] [Q]
  # [D] [P] [J] [F] [T] [G] [M] [T]
  # [P] [G] [B] [N] [L] [W] [P] [W] [R]
  # [Z] [V] [W] [J] [J] [C] [T] [S] [C]
  # [S] [N] [F] [G] [W] [B] [H] [F] [N]
  #  1   2   3   4   5   6   7   8   9

  @stacks %{
    1 => ["C", "F", "B", "L", "D", "P", "Z", "S"],
    2 => ["B", "W", "H", "P", "G", "V", "N"],
    3 => ["G", "J", "B", "W", "F"],
    4 => ["S", "C", "W", "L", "F", "N", "J", "G"],
    5 => ["H", "S", "M", "P", "T", "L", "J", "W"],
    6 => ["S", "F", "G", "W", "C", "B"],
    7 => ["W", "B", "Q", "M", "P", "T", "H"],
    8 => ["T", "W", "S", "F"],
    9 => ["R", "C", "N"]
  }

  def solution_1 do
    solution(append_like_stack: true)
  end

  def solution_2, do: solution()

  defp solution(), do: solution(append_like_stack: false)
  defp solution(append_like_stack: append_like_stack) do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ~r{\s*(move|from|to)\s*}, trim: true))
    |> Enum.reduce(@stacks, fn instruction, stacks ->
      [quantity, from, to] = Enum.map(instruction, &String.to_integer/1)

      dropped = Enum.take(Map.get(stacks, from), quantity)

      Map.update!(stacks, from, &Enum.drop(&1, quantity))
      |> Map.update!(to, fn items ->
        if append_like_stack do
          Enum.reverse(dropped, items)
        else
          dropped ++ items
        end
      end)
    end)
    |> collect_heads()
    |> Enum.join()
  end

  defp collect_heads(stacks) do
    Enum.reduce(9..1, [], fn index, accum ->
      head = List.first(stacks[index])
      if head, do: [head | accum], else: accum
    end)
  end
end
