defmodule CodeRunner.Application do
  @moduledoc false
  @pool_name Application.fetch_env!(:code_runner, :pool_name)
  @pool_size Application.fetch_env!(:code_runner, :pool_size)
  @pool_overflow Application.fetch_env!(:code_runner, :pool_overflow)

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config = [
      name: {:local, @pool_name},
      worker_module: CodeRunner.Worker,
      size: @pool_size,
      max_overflow: @pool_overflow,
    ]

    children = [
      :poolboy.child_spec(@pool_name, poolboy_config, [])
    ]

    opts = [strategy: :one_for_one, name: CodeRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
