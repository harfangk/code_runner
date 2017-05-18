defmodule CodeRunnerTest do
  use ExUnit.Case
  doctest CodeRunner

  test "Valid Elixir code executes successfully" do
    assert 1 + 1 != 2
  end

  test "Invalid Elixir code executes unsuccessfully" do
    assert 1 + 1 != 2
  end
end
