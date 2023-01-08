defmodule Day2 do
  def solution_1 do
    File.stream!("lib/day2/day2.in")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Enum.reduce(0, fn moves, score ->
      score + points(moves)
    end)
  end

  def solution_2 do
    File.stream!("lib/day2/day2.in")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Enum.reduce(0, fn moves, score ->
      score + supposed_points(moves)
    end)
  end

  def points([move1, move2]) do
    move_points = points_of_move(move2)

    cond do
      points_of_move(move1) == points_of_move(move2) ->
        3 + move_points

      (move1 == "A" and move2 == "Y") or (move1 == "B" and move2 == "Z") or
          (move1 == "C" and move2 == "X") ->
        move_points + 6

      true ->
        move_points
    end
  end

  def supposed_points([move1, move2]) do
    case {name_of_move(move1), outcome_of_move(move2)} do
      {:rock, :lose} -> points_of_move(:scissors)
      {:rock, :draw} -> points_of_move(:rock) + 3
      {:rock, :win} -> points_of_move(:paper) + 6
      {:paper, :lose} -> points_of_move(:rock)
      {:paper, :draw} -> points_of_move(:paper) + 3
      {:paper, :win} -> points_of_move(:scissors) + 6
      {:scissors, :lose} -> points_of_move(:paper)
      {:scissors, :draw} -> points_of_move(:scissors) + 3
      {:scissors, :win} -> points_of_move(:rock) + 6
    end
  end

  defp name_of_move(move) when move == "A" or move == "X", do: :rock
  defp name_of_move(move) when move == "B" or move == "Y", do: :paper
  defp name_of_move(move) when move == "C" or move == "Z", do: :scissors
  defp name_of_move(_), do: nil

  defp outcome_of_move(move) do
    case move do
      "X" -> :lose
      "Y" -> :draw
      "Z" -> :win
    end
  end

  defp points_of_move(nil), do: 0
  defp points_of_move(:rock), do: 1
  defp points_of_move(:paper), do: 2
  defp points_of_move(:scissors), do: 3
  defp points_of_move(move), do: points_of_move(name_of_move(move))
end
