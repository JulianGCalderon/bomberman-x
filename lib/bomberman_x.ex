defmodule BombermanX do
  defstruct [:cells]
  @type t :: %BombermanX{cells: list(list(String.t()))}

  @moduledoc """
  Documentation for `BombermanX`.
  """

  @spec load!(Path.t()) :: t()
  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    cells = Enum.map(file, &String.split(&1))

    %BombermanX{cells: cells}
  end

  def trigger!(bomberman, bomb_x, bomb_y) do
    bomberman
  end

  @spec save!(Path.t(), t()) :: :ok
  def save!(path, bomberman) do
    file = File.open!(path, [:write])

    Enum.each(bomberman.cells, &IO.puts(file, Enum.intersperse(&1, " ")))
  end
end
