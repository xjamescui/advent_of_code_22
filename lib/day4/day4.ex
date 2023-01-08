defmodule Day4 do
  @input_path "lib/day4/day4.in"

  def solution_1 do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&parse_numbers(&1))
    |> Enum.count(&fully_overlap?/1)
  end

  def solution_2 do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&parse_numbers(&1))
    |> Enum.count(&overlap?/1)
  end

  defp fully_overlap?([[lower1, upper1], [lower2, upper2]]) do
    (lower1 >= lower2 and upper1 <= upper2) or (lower2 >= lower1 and upper2 <= upper1)
  end

  defp overlap?([[lower1, upper1], [lower2, upper2]]) do
    not Range.disjoint?(lower1..upper1, lower2..upper2)
  end

  defp parse_numbers([range_text1, range_text2]) do
    [
      String.split(range_text1, "-") |> Enum.map(&String.to_integer/1),
      String.split(range_text2, "-") |> Enum.map(&String.to_integer/1)
    ]
  end
end
