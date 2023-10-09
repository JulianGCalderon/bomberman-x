defmodule BombermanTest do
  alias Element.Enemy
  use ExUnit.Case
  doctest Bomberman

  test "detonate removes bomb" do
    board = Board.load!("boards/propagate_right.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert :empty = Board.at(board, {0, 0})
  end

  test "detonate expects bomb" do
    board = Board.load!("boards/propagate_right.txt")

    assert {:error, :not_bomb} = Bomberman.detonate(board, {1, 0})
  end

  test "bomb propagates right" do
    board = Board.load!("boards/propagate_right.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert :empty = Board.at(board, {1, 0})
    assert :empty = Board.at(board, {2, 0})
    assert :empty = Board.at(board, {3, 0})
    assert %Enemy{health: 1} = Board.at(board, {4, 0})
  end

  test "rock blocks normal bomb" do
    board = Board.load!("boards/rocks.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert %Enemy{health: 1} = Board.at(board, {2, 0})
  end

  test "pierce bomb pierces rock" do
    board = Board.load!("boards/rocks.txt")

    board = Bomberman.detonate(board, {0, 3})

    assert :empty = Board.at(board, {2, 3})
  end

  test "wall blocks bomb" do
    board = Board.load!("boards/walls.txt")

    board = Bomberman.detonate(board, {0, 0})
    board = Bomberman.detonate(board, {0, 3})

    assert %Enemy{health: 1} = Board.at(board, {2, 0})
    assert %Enemy{health: 1} = Board.at(board, {2, 3})
  end

  test "bombs trigger each other" do
    board = Board.load!("boards/chain.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert :empty = Board.at(board, {6, 6})
  end

  test "detours change blast direction" do
    board = Board.load!("boards/detour.txt")

    board = Bomberman.detonate(board, {0, 0})

    assert %Enemy{health: 1} = Board.at(board, {0, 6})
  end
end
