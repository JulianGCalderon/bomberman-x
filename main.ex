
[input_path, output_path, bomb_x, bomb_y] = System.argv()

{bomb_x, _} = Integer.parse(bomb_x)
{bomb_y, _} = Integer.parse(bomb_y)

board = Board.load!(input_path)

case Bomberman.trigger(board, {bomb_x, bomb_y}) do
  { :ok, board } -> Board.save!(board, output_path)
  { :error, error } -> IO.puts("Error: #{error}")
end

