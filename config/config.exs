use Mix.Config

config :porcelain,
  driver: Porcelain.Driver.Basic

config :code_runner,
  pool_name: :code_runner_pool,
  timeout: 5000,
  pool_size: 50,
  pool_overflow: 10,
  docker_image: "harfangk/elixir:latest",
  docker_memory: "50m"
