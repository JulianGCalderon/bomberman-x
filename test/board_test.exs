defmodule BoardTest do
  use ExUnit.Case
  doctest Board

  def test_parsing_ok(path) do
    content = File.read!(path)

    assert {:ok, board} = Board.from_string(content)

    stringed = IO.chardata_to_string(Board.to_strings(board))

    assert stringed == content
  end

  def test_parsing_error(path, expected_error) do
    content = File.read!(path)

    result = Board.from_string(content)

    assert result == {:error, expected_error}
  end

  test "all elements" do
    test_parsing_ok("boards/all_elements.txt")
  end

  test "smaller board" do
    test_parsing_ok("boards/smaller_board.txt")
  end

  test "multiple_digits" do
    test_parsing_ok("boards/multiple_digits.txt")
  end

  test "unknown_element" do
    test_parsing_error("boards/unknown_element.txt", :invalid_type)
  end

  test "invalid_digit" do
    test_parsing_error("boards/invalid_digit.txt", :invalid_number)
  end

  test "invalid_direction" do
    test_parsing_error("boards/invalid_direction.txt", :invalid_direction)
  end

  test "zero_number" do
    test_parsing_error("boards/zero_number.txt", :invalid_number)
  end

  test "accessing elements" do
    board = Board.load!("boards/all_elements.txt")

    assert :empty = Board.at(board, {1, 0})
    assert :rock = Board.at(board, {4, 1})
    assert :wall = Board.at(board, {2, 2})
    assert %Element.Bomb{range: 6, type: :normal} = Board.at(board, {5, 3})
    assert %Element.Bomb{range: 4, type: :pierce} = Board.at(board, {3, 4})
    assert %Element.Enemy{health: 1} = Board.at(board, {0, 5})
    assert %Element.Detour{direction: :down} = Board.at(board, {1, 6})
  end

  test "modifying elements" do
    board = Board.load!("boards/clean.txt")

    board = Board.put(board, {4, 1}, :rock)
    assert :rock = Board.at(board, {4, 1})

    board = Board.put(board, {2, 2}, :wall)
    assert :wall = Board.at(board, {2, 2})

    board = Board.put(board, {5, 3}, %Element.Bomb{range: 6, type: :normal})
    assert %Element.Bomb{range: 6, type: :normal} = Board.at(board, {5, 3})

    board = Board.put(board, {3, 4}, %Element.Bomb{range: 6, type: :pierce})
    assert %Element.Bomb{range: 6, type: :pierce} = Board.at(board, {3, 4})

    board = Board.put(board, {0, 5}, %Element.Enemy{health: 1})
    assert %Element.Enemy{health: 1} = Board.at(board, {0, 5})

    board = Board.put(board, {1, 6}, %Element.Detour{direction: :down})
    assert %Element.Detour{direction: :down} = Board.at(board, {1, 6})
  end

  test "fetching elements" do
    board = Board.load!("boards/all_elements.txt")

    assert {:ok, :empty} = Board.fetch(board, {1, 0})
    assert {:error, :negative_position} = Board.fetch(board, {-1, 0})
    assert {:error, :out_of_bounds} = Board.fetch(board, {35, 0})
  end
end
