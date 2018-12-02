defmodule WizTest do
  use ExUnit.Case
  doctest Wiz

  test "greets the world" do
    assert Wiz.hello() == :world
  end
end
