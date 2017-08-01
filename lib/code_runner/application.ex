defmodule CodeRunner.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
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

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: CodeRunner.Worker.start_link(arg1, arg2, arg3)
      # worker(CodeRunner.Worker, [arg1, arg2, arg3]),
      :poolboy.child_spec(@pool_name, poolboy_config, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CodeRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
