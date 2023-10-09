defmodule BombermanTest do
  use ExUnit.Case
  doctest Bomberman

  test "detonate removes bomb" do
    board = Board.load!("boards/propagate_right.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert :empty = Board.at(board, {0, 0})
  end

  test "detonate expects bomb" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:error, :no_bomb} = Bomberman.detonate(board, {1, 0})
  end
end
