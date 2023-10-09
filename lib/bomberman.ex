defmodule Bomberman do
  def detonate(board, position) do
    bomb = Board.at(board, position)

    with %Element.Bomb{} <- bomb do
      board = Board.put(board, position, :empty)
      board
    else
      _ -> {:error, :no_bomb}
    end
  end
end
