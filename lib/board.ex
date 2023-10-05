defmodule Board do
  @type t :: list(list(element))
  @type element :: :empty | :rock | :wall | Bomb.t() | Detour.t() | Enemy.t()

  def load!(path) do
    file = File.stream!(path, [:utf8], :line)

    for line <- file do
      String.split(line)
    end
  end

  def save!(board, path) do
    file = File.open!(path, [:write])

    Enum.each(board, &IO.puts(file, Enum.intersperse(&1, " ")))
  end
end

defmodule Bomb do
  defstruct [:range, :type]
  @type t :: %Bomb{:range => integer(), :type => bomb_type()}
  @type bomb_type :: :normal | :pierce
end

defmodule Detour do
  defstruct [:direction]
  @type t :: %Detour{:direction => direction()}
  @type direction :: :up | :down | :left | :right
end

defmodule Enemy do
  defstruct [:health]
  @type t :: %Enemy{:health => integer()}
end
