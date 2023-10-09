defmodule Element do
  @type t :: :empty | :rock | :wall | Bomb.t() | Detour.t() | Enemy.t()
  @type bomb_type :: :normal | :pierce

  defmodule Bomb do
    defstruct [:range, :type]
    @type t :: %Element.Bomb{:range => integer(), :type => Element.bomb_type()}
  end

  defmodule Enemy do
    defstruct [:health]
    @type t :: %Element.Enemy{:health => integer()}
  end

  defmodule Detour do
    defstruct [:direction]
    @type t :: %Element.Detour{:direction => direction()}
    @type direction :: :up | :down | :left | :right

    def parse_direction(?D), do: {:ok, :down}
    def parse_direction(?U), do: {:ok, :up}
    def parse_direction(?L), do: {:ok, :left}
    def parse_direction(?R), do: {:ok, :right}
    def parse_direction(_), do: {:error, :invalid_direction}

    def display_direction(:up), do: "U"
    def display_direction(:down), do: "D"
    def display_direction(:left), do: "L"
    def display_direction(:right), do: "R"

    def all_directions() do
      [:up, :right, :down, :left]
    end
  end

  def parse_integer(number) do
    with {integer, _} when integer != 0 <- Integer.parse(number) do
      {:ok, integer}
    else
      _ -> {:error, :invalid_number}
    end
  end

  def parse(<<?_>>), do: {:ok, :empty}
  def parse(<<?R>>), do: {:ok, :rock}
  def parse(<<?W>>), do: {:ok, :wall}

  def parse(<<?D, direction>>) do
    with {:ok, direction} <- Detour.parse_direction(direction) do
      detour = %Detour{direction: direction}
      {:ok, detour}
    end
  end

  def parse(<<?F, health::binary>>) do
    with {:ok, health} <- parse_integer(health) do
      enemy = %Enemy{health: health}
      {:ok, enemy}
    end
  end

  def parse(<<?B, range::binary>>) do
    with {:ok, range} <- parse_integer(range) do
      bomb = %Bomb{range: range, type: :normal}
      {:ok, bomb}
    end
  end

  def parse(<<?S, range::binary>>) do
    with {:ok, range} <- parse_integer(range) do
      bomb = %Bomb{range: range, type: :pierce}
      {:ok, bomb}
    end
  end

  def parse(_), do: {:error, :invalid_type}

  def display(:empty), do: "_"
  def display(:rock), do: "R"
  def display(:wall), do: "W"

  def display(%Detour{direction: direction}) do
    "D" <> Detour.display_direction(direction)
  end

  def display(%Enemy{health: health}) do
    "F" <> Integer.to_string(health)
  end

  def display(%Bomb{range: range, type: bomb_type}) do
    display_bomb_type(bomb_type) <> Integer.to_string(range)
  end

  def display_bomb_type(:pierce), do: "S"
  def display_bomb_type(:normal), do: "B"
end
