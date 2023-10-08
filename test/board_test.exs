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
end
