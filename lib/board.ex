defmodule Board do
  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    for line <- file do
      for element <- String.split(line) do
        Element.parse(element)
      end
    end
  end

  def save!(board, path) do
    file = File.open!(path, [:write])

    IO.puts(file, Board.to_strings(board))
  end

  def to_strings(board) do
    Enum.map_intersperse(board, "\n", &Board.row_to_strings/1)
  end

  def row_to_strings(row) do
    Enum.map_intersperse(row, " ", &Element.display/1)
  end
end

defmodule Element do
  @type t :: :empty | :rock | :wall | Bomb.t() | Detour.t() | Enemy.t()

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

  def parse_direction(?D), do: :down
  def parse_direction(?U), do: :up
  def parse_direction(?L), do: :left
  def parse_direction(?R), do: :right

  def parse_digit(digit) when digit in ?0..?9 do
    digit - ?0
  end

  def parse(<<?_>>), do: :empty
  def parse(<<?R>>), do: :rock
  def parse(<<?W>>), do: :wall

  def parse(<<?D, direction>>) do
    %Detour{direction: parse_direction(direction)}
  end

  def parse(<<?F, health>>) do
    %Enemy{health: parse_digit(health)}
  end

  def parse(<<?B, range>>) do
    %Bomb{range: parse_digit(range), type: :normal}
  end

  def parse(<<?S, range>>) do
    %Bomb{range: parse_digit(range), type: :pierce}
  end

  def display_direction(:up), do: "U"
  def display_direction(:down), do: "D"
  def display_direction(:left), do: "L"
  def display_direction(:right), do: "R"

  def display_bomb_type(:pierce), do: "S"
  def display_bomb_type(:normal), do: "B"

  def display_digit(digit) when digit in 0..9 do
    <<?0 + digit>>
  end

  def display(:empty), do: "_"
  def display(:rock), do: "R"
  def display(:wall), do: "W"

  def display(%Detour{direction: direction}) do
    "D" <> display_direction(direction)
  end

  def display(%Enemy{health: health}) do
    "F" <> display_digit(health)
  end

  def display(%Bomb{range: range, type: bomb_type}) do
    display_bomb_type(bomb_type) <> display_digit(range)
  end
end
