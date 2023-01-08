defmodule Day1 do
  def solution_1 do
    File.stream!("lib/day1/day1.in")
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 !== ""))
    |> Stream.reject(&(&1 == [""]))
    |> Stream.map(&sum_of/1)
    |> Enum.max()
  end

  def solution_2 do
    File.stream!("lib/day1/day1.in")
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 !== ""))
    |> Stream.reject(&(&1 == [""]))
    |> Stream.map(&sum_of/1)
    |> Enum.sort(:desc)
    |> Stream.take(3)
    |> Enum.sum()
  end

  defp sum_of(texts) do
    texts |> Stream.map(&String.to_integer/1) |> Enum.sum()
  end
end
