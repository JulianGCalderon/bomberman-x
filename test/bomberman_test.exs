defmodule BombermanTest do
  alias Element.Enemy
  use ExUnit.Case
  doctest Bomberman

  test "detonate removes bomb" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert :empty = Board.at(board, {0, 0})
  end

  test "detonate expects bomb" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:error, :not_bomb} = Bomberman.trigger(board, {1, 0})
  end

  test "position must be valid" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:error, :negative_position} = Bomberman.trigger(board, {-1, 0})
    assert {:error, :out_of_bounds} = Bomberman.trigger(board, {56, 0})
    assert {:error, :negative_position} = Bomberman.trigger(board, {0, -1})
    assert {:error, :out_of_bounds} = Bomberman.trigger(board, {0, 32})
  end

  test "bomb propagates right" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert :empty = Board.at(board, {1, 0})
    assert :empty = Board.at(board, {2, 0})
    assert :empty = Board.at(board, {3, 0})
    assert %Enemy{health: 1} = Board.at(board, {4, 0})
  end

  test "rock blocks normal bomb" do
    board = Board.load!("boards/rocks.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert %Enemy{health: 1} = Board.at(board, {2, 0})
  end

  test "pierce bomb pierces rock" do
    board = Board.load!("boards/rocks.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 3})

    assert :empty = Board.at(board, {2, 3})
  end

  test "wall blocks bomb" do
    board = Board.load!("boards/walls.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})
    assert {:ok, board} = Bomberman.trigger(board, {0, 3})

    assert %Enemy{health: 1} = Board.at(board, {2, 0})
    assert %Enemy{health: 1} = Board.at(board, {2, 3})
  end

  test "bombs trigger each other" do
    board = Board.load!("boards/chain.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert :empty = Board.at(board, {6, 6})
  end

  test "detours change blast direction" do
    board = Board.load!("boards/detour.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert %Enemy{health: 1} = Board.at(board, {0, 6})
  end

  test "bomb damages once" do
    board = Board.load!("boards/bomb_damages_once.txt")

    assert {:ok, board} = Bomberman.trigger(board, {0, 0})

    assert %Enemy{health: 2} = Board.at(board, {2, 0})
  end
end
