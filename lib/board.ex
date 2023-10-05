defmodule Board do
  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    for line <- file do
      for element <- String.split(line) do
        Element.from_string(element)
      end
    end
  end

  def save!(board, path) do
    file = File.open!(path, [:write])

    Enum.each(Board.to_string_matrix(board), &IO.puts(file, Enum.intersperse(&1, " ")))
  end

  def to_string_matrix(board) do
    for row <- board do
      for element <- row do
        Element.to_string(element)
      end
    end
  end
end

defmodule Element do
  defmodule Bomb do
    defstruct [:range, :type]
    @type t :: %Element.Bomb{:range => integer(), :type => bomb_type()}
    @type bomb_type :: :normal | :pierce
  end

  defmodule Detour do
    defstruct [:direction]
    @type t :: %Element.Detour{:direction => direction()}
    @type direction :: :up | :down | :left | :right
  end

  defmodule Enemy do
    defstruct [:health]
    @type t :: %Element.Enemy{:health => integer()}
  end

  @type t :: :empty | :rock | :wall | Bomb.t() | Detour.t() | Enemy.t()

  def from_string(string) do
    case to_charlist(string) do
      [?_] -> :empty
      [?R] -> :rock
      [?W] -> :wall
      [?D, ?U] -> %Detour{direction: :up}
      [?D, ?D] -> %Detour{direction: :down}
      [?D, ?L] -> %Detour{direction: :left}
      [?D, ?R] -> %Detour{direction: :right}
      [?F, health] -> %Enemy{health: health - ?0}
      [?B, range] -> %Bomb{range: range - ?0, type: :normal}
      [?S, range] -> %Bomb{range: range - ?0, type: :pierce}
    end
  end

  def to_string(element) do
    case element do
      :empty -> "_"
      :rock -> "R"
      :wall -> "W"
      %Detour{direction: :up} -> "DU"
      %Detour{direction: :down} -> "DD"
      %Detour{direction: :left} -> "DL"
      %Detour{direction: :right} -> "DR"
      %Enemy{health: health} -> "F" <> Integer.to_string(health, 10)
      %Bomb{range: range, type: :normal} -> "B" <> Integer.to_string(range, 10)
      %Bomb{range: range, type: :pierce} -> "S" <> Integer.to_string(range, 10)
    end
  end
end
