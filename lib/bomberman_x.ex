defmodule BombermanX do
  defstruct [:board, :width, :height]

  @type t :: %BombermanX{:board => board(), :width => integer(), :height => integer()}
  @type board :: %{required({integer(), integer()}) => element()}
  @type element :: String.t()
  @type matrix :: list(list(element))

  @spec load!(Path.t()) :: t()
  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    board =
      for {line, y} <- Enum.with_index(file),
          {element, x} <- Enum.with_index(String.split(line)),
          into: %{} do
        {{x, y}, element}
      end

    width = Map.keys(board) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    height = Map.keys(board) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    %BombermanX{board: board, width: width, height: height}
  end

  def trigger!(bomberman, _bomb_x, _bomb_y) do
    bomberman
  end

  @spec save!(t(), Path.t()) :: :ok
  def save!(bomberman, path) do
    to_matrix(bomberman) |> save_matrix!(path)
  end

  @spec to_matrix(t()) :: matrix()
  def to_matrix(bomberman) do
    for y <- 0..(bomberman.height - 1) do
      for x <- 0..(bomberman.width - 1) do
        Map.get(bomberman.board, {x, y})
      end
    end
  end

  @spec save_matrix!(Path.t(), matrix()) :: :ok
  def save_matrix!(matrix, path) do
    file = File.open!(path, [:write])

    Enum.each(matrix, &IO.puts(file, Enum.intersperse(&1, " ")))
  end
end
