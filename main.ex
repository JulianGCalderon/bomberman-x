require BombermanX

[input_path, output_path, bomb_x, bomb_y] = System.argv()

bomberman = BombermanX.load!(input_path)

bomberman = BombermanX.trigger!(bomberman, bomb_x, bomb_y)

BombermanX.save!(output_path, bomberman)
