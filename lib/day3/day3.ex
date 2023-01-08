defmodule Day3 do
  @input_path "lib/day3/day3.in"
  def solution_1 do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&to_charlist(&1))
    |> Stream.map(&make_halves/1)
    |> Stream.map(fn xs -> Enum.map(xs, &MapSet.new/1) end)
    |> Stream.map(&find_redundant_char/1)
    |> sum_chars()
  end

  def solution_2 do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&to_charlist(&1))
    |> Stream.chunk_every(3)
    |> Stream.map(fn xs -> Enum.map(xs, &MapSet.new/1) end)
    |> Stream.map(&find_redundant_char/1)
    |> sum_chars()
  end

  defp make_halves(chars) do
    Enum.chunk_every(chars, div(length(chars), 2))
  end

  defp sum_chars(chars) do
    Enum.reduce(chars, 0, fn value, sum ->
      cond do
        # uppercase
        value >= 65 and value <= 90 -> sum + value - 38
        # lowercase
        true -> sum + value - 96
      end
    end)
  end

  defp find_redundant_char([]), do: nil
  defp find_redundant_char([set | char_sets]) do
    Enum.reduce(char_sets, set, &MapSet.intersection/2) |> MapSet.to_list() |> hd()
  end

end
