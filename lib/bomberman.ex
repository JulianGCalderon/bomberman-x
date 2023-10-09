defmodule Bomberman do
  alias Element.Detour
  alias Element.Bomb

  def detonate(board, position) do
    with {:ok, bomb} <- Board.fetch(board, position) do
      if is_struct(bomb, Bomb) do
        {:ok, explode(board, position, bomb)}
      else
        {:error, :not_bomb}
      end
    end
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
