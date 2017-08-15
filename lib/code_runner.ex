defmodule CodeRunner do
  @moduledoc """
  CodeRunner is the public interface module of this application.
  """

  @doc """
  Executes given Elixir code in a sandbox environment concurrently and returns the result in string format. 

  ## Examples

      iex> CodeRunner.run("3+5")
      "8\\n"

  """

  @spec run(code :: String.t) :: String.t
  def run(code) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> GenServer.call(pid, {:run_code, code}, :infinity) end,
      :infinity
    )
  end

  defp pool_name do
    case Application.fetch_env(:code_runner, :pool_name) do
      {:ok, pool_name} -> pool_name
      _ -> :code_runner_pool
    end
  end
end
