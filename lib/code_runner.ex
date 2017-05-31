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
    result = Porcelain.exec("elixir", ["-e", "#{code}"], err: :out)
    result.out
  end
end
