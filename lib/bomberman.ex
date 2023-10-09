defmodule Bomberman.Blast do
  alias Element.Enemy
  defstruct [:board, :position, :bomb, :direction]

  def propagate(blast) when blast.bomb.range > 0 do
    bomb = blast.bomb
    bomb = %{bomb | range: bomb.range - 1}
    position = advance(blast.position, blast.direction)

    blast = %{blast | position: position, bomb: bomb}

    blast = apply(blast)

    propagate(blast)
  end

  def propagate(blast) when blast.bomb.range == 0 do
    blast
  end

  def apply(blast) do
    case Board.at(blast.board, blast.position) do
      %Element.Enemy{health: health} ->
        board =
          if health == 1 do
            Board.put(blast.board, blast.position, :empty)
          else
            Board.put(blast.board, blast.position, %Enemy{health: health - 1})
          end

        %{blast | board: board}
    end
  end

  def advance({x, y}, direction) do
    case direction do
      :right -> {x + 1, y}
      :left -> {x - 1, y}
      :up -> {x, y - 1}
      :down -> {x, y + 1}
    end
  end
end

defmodule Bomberman do
  alias Bomberman.Blast

  def detonate(board, position) do
    bomb = Board.at(board, position)

    with %Element.Bomb{} <- bomb do
      explode(board, position, bomb)
    else
      _ -> {:error, :no_bomb}
    end
  end

  def explode(board, position, bomb) do
    board = Board.put(board, position, :empty)

    blast = %Blast{board: board, position: position, bomb: bomb, direction: :right}

    blast = Blast.propagate(blast)

    blast.board
  end
end
