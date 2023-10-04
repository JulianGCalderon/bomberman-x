defmodule BombermanXTest do
  use ExUnit.Case
  doctest BombermanX

  test "greets the world" do
    assert BombermanX.hello() == :world
  end
end
