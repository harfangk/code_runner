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
    {:ok, %Porcelain.Result{err: _, out: output, status: _}} = 
      Porcelain.spawn("elixir", ["-e", "#{code}"], err: :out)
      |> Porcelain.Process.await(5000)
    output
  end
end
