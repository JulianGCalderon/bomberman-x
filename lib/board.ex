defmodule Board do
  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    from_lines!(file)
  end

  def save!(board, path) do
    file = File.open!(path, [:write])

    IO.puts(file, Board.to_strings(board))
  end

  def at(board, {x, y}) do
    Enum.at(board, y) |> Enum.at(x)
  end

  def fetch(board, {x, y}) when {x, y} >= {0, 0} do
    with {:ok, row} <- Enum.fetch(board, y),
         {:ok, element} <- Enum.fetch(row, x) do
      {:ok, element}
    else
      :error -> {:error, :out_of_bounds}
    end
  end

  def fetch(_board, {x, y}) when x < 0 or y < 0 do
    {:error, :negative_position}
  end

  def put(board, {x, y}, element) do
    new_row = List.replace_at(Enum.at(board, y), x, element)
    List.replace_at(board, y, new_row)
  end

  def from_string(string) do
    from_lines(String.split(string, "\n"))
  end

  def from_lines!(lines) do
    case from_lines(lines) do
      {:ok, board} -> board
      error -> raise error
    end
  end

  def from_lines(lines) do
    Utils.try_map(lines, fn line ->
      Utils.try_map(String.split(line), fn element ->
        Element.parse(element)
      end)
    end)
  end

  def to_strings(board) do
    Enum.map_intersperse(board, "\n", fn row ->
      Enum.map_intersperse(row, " ", &Element.display/1)
    end)
  end
end
