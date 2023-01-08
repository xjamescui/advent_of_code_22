defmodule Day7 do
  @input_path "lib/day7/day7.in"

  @total_disk_space 70_000_000
  @min_required_disk_space 30_000_000

  def solution_1 do
    File.stream!(@input_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> tree_from_stream()
    |> walk(["/"])
    |> elem(1)
  end

  defp walk(tree, breadcrumbs, total \\ 0) do
    Map.get(tree, breadcrumbs, [])
    |> Enum.reduce({0, total}, fn {name, value}, {sum, total} ->
      cond do
        is_integer(value) ->
          {sum + value, total}

        true ->
          {folder_size, total} = walk(tree, [name | breadcrumbs], total)

          if folder_size <= 100_000 do
            {sum + folder_size, total + folder_size}
          else
            {sum + folder_size, total}
          end
      end
    end)
  end

  defp tree_from_stream(stream) do
    Enum.reduce(stream, %{tree: %{}, breadcrumbs: []}, fn instruction,
                                                          %{tree: tree, breadcrumbs: breadcrumbs} =
                                                            info ->
      case instruction do
        [_, "cd", "/"] ->
          %{info | breadcrumbs: ["/"]}

        [_, "cd", ".."] ->
          %{info | breadcrumbs: Enum.drop(breadcrumbs, 1)}

        [_, "cd", dir] ->
          %{info | breadcrumbs: [dir | breadcrumbs]}

        ["dir", dir] ->
          %{info | tree: update_size_if_needed(tree, breadcrumbs, dir)}

        [_, "ls"] ->
          info

        [size, file_name] ->
          %{
            info
            | tree: update_size_if_needed(tree, breadcrumbs, file_name, String.to_integer(size))
          }

        _ ->
          info
      end
    end)
    |> Map.get(:tree)
  end

  defp update_size_if_needed(tree, breadcrumbs, dir_name) do
    Map.get_and_update(tree, breadcrumbs, fn current_map ->
      {current_map, Map.put_new(current_map || %{}, dir_name, true)}
    end)
    |> elem(1)
  end

  defp update_size_if_needed(tree, breadcrumbs, file_name, size) do
    Map.get_and_update(tree, breadcrumbs, fn current_map ->
      {current_map, Map.put_new(current_map || %{}, file_name, size)}
    end)
    |> elem(1)
  end
end
