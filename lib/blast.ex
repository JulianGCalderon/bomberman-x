defmodule Blast do
  alias Element.Detour
  alias Element.Enemy
  alias Element.Bomb

  defstruct [:board, :position, :direction, :range, :type]

  def new(board, position, bomb, direction) do
    %{type: type, range: range} = bomb
    %Blast{board: board, position: position, direction: direction, range: range, type: type}
  end

  def propagate(blast) when blast.range > 0 do
    blast = advance(blast)

    with {:ok, cell} <- Board.fetch(blast.board, blast.position),
         {:cont, blast} <- apply_on(blast, cell) do
      propagate(blast)
    else
      :error -> blast
      {:halt, blast} -> blast
    end
  end

  def propagate(blast) when blast.range == 0 do
    blast
  end

  def apply_on(blast, enemy) when is_struct(enemy, Enemy) do
    new_cell = damage_enemy(enemy)

    board = Board.put(blast.board, blast.position, new_cell)

    blast = %{blast | board: board}

    {:cont, blast}
  end

  def apply_on(blast, bomb) when is_struct(bomb, Bomb) do
    board = Bomberman.detonate_bomb(blast.board, blast.position, bomb)

    blast = %{blast | board: board}

    {:cont, blast}
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

  def damage_enemy(%Enemy{health: 1}) do
    :empty
  end

  def damage_enemy(%Enemy{health: health}) do
    %Enemy{health: health - 1}
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
