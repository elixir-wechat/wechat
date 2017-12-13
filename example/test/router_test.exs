defmodule RouterTest do
  use ExUnit.Case
  doctest Router

  test "greets the world" do
    assert Router.hello() == :world
  end
end
