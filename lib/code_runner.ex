defmodule CodeRunner do
  @moduledoc """
  Documentation for CodeRunner.
  """

  @doc """
  Public API for running code. 

  ## Examples

      iex> CodeRunner.run("IO.puts(:hello)")
      "hello\\n"

  """
  def run(code) do
    Porcelain.spawn("elixir", ["-e", "#{code}"], err: :out)
    |> Porcelain.Process.await(5000)
  end
end
