require BombermanX

[input_path, output_path, _bomb_x, _bomb_y] = System.argv()

bomberman = Board.load!(input_path)

Board.save!(bomberman, output_path)
