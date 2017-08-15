defmodule CodeRunner.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config = [
      name: {:local, pool_name()},
      worker_module: CodeRunner.Worker,
      size: pool_size(),
      max_overflow: pool_overflow(),
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    opts = [strategy: :one_for_one, name: CodeRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pool_name do
    case Application.fetch_env(:code_runner, :pool_name) do
      {:ok, pool_name} -> pool_name
      _ -> :code_runner_pool
    end
  end

  defp pool_size do
    case Application.fetch_env(:code_runner, :pool_size) do
      {:ok, pool_size} -> pool_size
      _ -> 50
    end
  end

  defp pool_overflow do
    case Application.fetch_env(:code_runner, :pool_overflow) do
      {:ok, pool_overflow} -> pool_overflow
      _ -> 10
    end
  end
end
