defmodule Bomberman do
  alias Element.Enemy
  alias Element.Detour
  alias Element.Bomb

  def trigger(board, position) do
    with {:ok, bomb} <- Board.fetch(board, position) do
      if is_struct(bomb, Bomb) do
        {:ok, explode_element(board, position, bomb)}
      else
        {:error, :not_bomb}
      end
    end
  end

  def explode(board, position) do
    element = Board.at(board, position)

    explode_element(board, position, element)
  end

  def explode_element(board, position, bomb) when is_struct(bomb, Bomb) do
    board = Board.put(board, position, :empty)

    cells = calculate_explosion(board, position, bomb)

    for cell <- cells, reduce: board do
      board -> explode(board, cell)
    end
  end

  def explode_element(board, position, enemy) when is_struct(enemy, Enemy) do
    new_cell = damage_enemy(enemy)

    Board.put(board, position, new_cell)
  end

  def calculate_explosion(board, position, bomb) do
    for direction <- Detour.all_directions(), reduce: MapSet.new() do
      set ->
        Blast.calculate(board, position, bomb, direction) |> MapSet.union(set)
    end
  end

  def damage_enemy(%Enemy{health: 1}) do
    :empty
  end

  def damage_enemy(%Enemy{health: health}) do
    %Enemy{health: health - 1}
  end
end
