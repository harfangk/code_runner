defmodule CodeRunner do
  @moduledoc """
  Documentation for CodeRunner.
  """

  @pool_name Application.fetch_env!(:code_runner, :pool_name)

  @doc """
  Public API for running code. 

  ## Examples

      iex> CodeRunner.run("IO.puts(:hello)")
      "hello\\n"

  """
  def run(code) do
    :poolboy.transaction(
      @pool_name,
      fn(pid) -> GenServer.call(pid, {:run_code, code}, :infinity) end,
      :infinity
    )
  end
end
