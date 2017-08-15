# CodeRunner

CodeRunner takes Elixir code, compiles and runs it in an isolated sandbox, and
returns the result in string format. A pool of workers managed by `:poolboy`
runs the code, using Docker containers as a reasonably secure sandbox
environment. If security is a critical concern in your software, it is
recommended to more robust and secure solutions.

## Installation

Add `code_runner` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:code_runner, "~> 0.1"}]
end
```

CodeRunner employs Docker container as sandbox, so it requires Docker
installation. Check out official [Docker installation
guide](https://docs.docker.com/engine/installation/) for installing Docker.

Once you have installed Docker, pull the Docker image used in the application.
For default image, run:

```shell
$ docker pull harfangk/elixir:latest
```

## Configuration

You can configure options that can adjust the performance and resource
consumption of this application.

```elixir
config :code_runner,
  pool_name: :code_runner_pool, # name of the poolboy worker pool
  timeout: 5000, # timeout duration after which code will be forcefully terminated
  pool_size: 50, # number of workers that spawns a Docker container and runs
  code
  pool_overflow: 10, # maximum number of temporary overflow workers
  docker_image: "harfangk/elixir:latest", # Docker image for container
  docker_memory: "50m" # memory allocated to each Docker container
```
