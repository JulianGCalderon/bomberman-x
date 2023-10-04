defmodule BombermanXTest do
  use ExUnit.Case
  doctest BombermanX

  test "" do
    assert BombermanX.hello() == :world
  end
end
