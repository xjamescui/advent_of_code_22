defmodule Day6 do
  @input_path "lib/day6/day6.in"
  def solution_1 do
    File.stream!(@input_path, [], 1)
    |> find_marker(window_size: 4)
  end

  def solution_2 do
    File.stream!(@input_path, [], 1)
    |> find_marker(window_size: 14)
  end

  @spec find_marker(stream :: File.Stream.t(), window_size: pos_integer()) :: pos_integer()
  defp find_marker(stream, window_size: window_size) do
    {_, _, marker} =
      stream
      |> Enum.reduce({[], 0, nil}, fn char, {window, index, marker} ->
        cond do
          marker -> {window, index, marker}
          length(window) < window_size -> {window ++ [char], index + 1, marker}
          unique?(window) -> {window, index, index}
          true -> {Enum.drop(window, 1) ++ [char], index + 1, marker}
        end
      end)

    marker
  end

  def unique?([]), do: false

  def unique?(list) do
    {_, is_unique} =
      Enum.reduce_while(list, {%MapSet{}, true}, fn item, {set, is_unique} ->
        if MapSet.member?(set, item) do
          {:halt, {set, false}}
        else
          {:cont, {MapSet.put(set, item), is_unique}}
        end
      end)

    is_unique
  end
end
