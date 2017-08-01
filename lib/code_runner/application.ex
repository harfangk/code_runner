defmodule CodeRunner.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config = [
      {:name, {:local, :code_runner_pool}},
      {:worker_module, CodeRunner.Worker},
      {:size, 100},
      {:max_overflow, 10},
    ]

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: CodeRunner.Worker.start_link(arg1, arg2, arg3)
      # worker(CodeRunner.Worker, [arg1, arg2, arg3]),
      :poolboy.child_spec(:code_runner_pool, poolboy_config, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CodeRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
