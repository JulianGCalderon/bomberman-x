
[input_path, output_path, bomb_x, bomb_y] = System.argv()

{bomb_x, _} = Integer.parse(bomb_x)
{bomb_y, _} = Integer.parse(bomb_y)

board = Board.load!(input_path)

board = Bomberman.detonate(board, {bomb_x, bomb_y})

Board.save!(board, output_path)
