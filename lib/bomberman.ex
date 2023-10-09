defmodule Bomberman do
  alias Element.Detour
  alias Element.Bomb

  def detonate(board, position) do
    bomb = Board.at(board, position)

    detonate_bomb(board, position, bomb)
  end

  def detonate_bomb(board, position, bomb) when is_struct(bomb, Bomb) do
    explode(board, position, bomb)
  end

  def detonate_bomb(_board, _position, not_bomb) when not is_struct(not_bomb, Bomb) do
    {:error, :not_bomb}
  end

  def explode(board, position, bomb) do
    board = Board.put(board, position, :empty)

    for direction <- Detour.all_directions(), reduce: board do
      board ->
        Blast.new(board, position, bomb, direction)
        |> Blast.propagate()
        |> Map.get(:board)
    end
  end
end
