defmodule Blast do
  alias Element.Detour

  defstruct [:board, :position, :direction, :bomb, affected: MapSet.new()]

  def new(board, position, bomb, direction) do
    struct(Blast, board: board, position: position, direction: direction, bomb: bomb)
  end

  def calculate(board, position, bomb, direction) do
    blast = new(board, position, bomb, direction)

    blast = propagate(blast)

    blast.affected
  end

  def propagate(blast) when blast.bomb.range > 0 do
    blast = advance(blast)

    with {:ok, element} <- Board.fetch(blast.board, blast.position),
         {:cont, blast} <- apply_on(blast, element) do
      propagate(blast)
    else
      {:halt, blast} -> blast
      {:error, _} -> blast
    end
  end

  def propagate(blast) when blast.bomb.range == 0 do
    blast
  end

  def apply_on(blast, detour) when is_struct(detour, Detour) do
    blast = put_in(blast.direction, detour.direction)

    {:cont, blast}
  end

  def apply_on(blast, :empty) do
    {:cont, blast}
  end

  def apply_on(blast, :rock) do
    case blast.bomb.type do
      :normal -> {:halt, blast}
      :pierce -> {:cont, blast}
    end
  end

  def apply_on(blast, :wall) do
    {:halt, blast}
  end

  def apply_on(blast, element) do
    affected = MapSet.put(blast.affected, {blast.position, element})

    blast = put_in(blast.affected, affected)

    {:cont, blast}
  end

  def advance(blast) do
    position = advance_position(blast.position, blast.direction)

    blast = put_in(blast.bomb.range, blast.bomb.range - 1)
    blast = put_in(blast.position, position)

    blast
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
