defmodule Blast do
  alias Element.Detour

  defstruct [:board, :position, :direction, :range, :type, affected: MapSet.new()]

  def new(board, position, bomb, direction) do
    %{type: type, range: range} = bomb
    %Blast{board: board, position: position, direction: direction, range: range, type: type}
  end

  def calculate(board, position, bomb, direction) do
    blast = new(board, position, bomb, direction)

    blast = propagate(blast)

    blast.affected
  end

  def propagate(blast) when blast.range > 0 do
    blast = advance(blast)

    with {:ok, cell} <- Board.fetch(blast.board, blast.position),
         {:cont, blast} <- apply_on(blast, cell) do
      propagate(blast)
    else
      {:halt, blast} -> blast
      {:error, _} -> blast
    end
  end

  def propagate(blast) when blast.range == 0 do
    blast
  end

  def apply_on(blast, detour) when is_struct(detour, Detour) do
    blast = %{blast | direction: detour.direction}

    {:cont, blast}
  end

  def apply_on(blast, :empty) do
    {:cont, blast}
  end

  def apply_on(blast, :rock) do
    case blast.type do
      :normal -> {:halt, blast}
      :pierce -> {:cont, blast}
    end
  end

  def apply_on(blast, :wall) do
    {:halt, blast}
  end

  def apply_on(blast, _) do
    affected = MapSet.put(blast.affected, blast.position)

    blast = %{blast | affected: affected}

    {:cont, blast}
  end

  def advance(blast) do
    position = advance_position(blast.position, blast.direction)
    range = blast.range - 1

    %{blast | range: range, position: position}
  end

  def advance_position({x, y}, direction) do
    case direction do
      :right -> {x + 1, y}
      :left -> {x - 1, y}
      :up -> {x, y - 1}
      :down -> {x, y + 1}
    end
  end
end
