defmodule CodeRunner.Worker do
  @moduledoc """
  Worker module responsible for actually running code. Each worker process spawns a Docker container in an external process, executes the code, returns the result or timeout message.

  ## Attributes

  A few attributes can be configured in `config.exs` to change Docker image or adjust resource consumption of each worker.

  * `@timeout` - determines how long the worker will wait for the code to terminate. Default is 5000.
  * `@docker_memory` - assigns how much memory should a sandbox Docker container should have. Default is "50m".
  * `@docker_image` - designates which Docker image to mount a sandbox container. Default is "harfangk/elixir:latest".
  """

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:run_code, code}, _from, state) do
    process = Porcelain.spawn("docker", docker_args() ++ ["#{code} |> IO.inspect()"], err: :out)

    result = Porcelain.Process.await(process, timeout())

    case result do
      {:ok, %Porcelain.Result{out: output}} ->
        {:reply, output, state}
      {:error, :timeout} ->
        Porcelain.Process.stop(process)
        {:reply, "Code took longer than #{timeout()}ms to run, resulting in timeout.", state}
    end
  end

  defp timeout do
    case Application.fetch_env(:code_runner, :timeout) do
      {:ok, timeout} -> timeout
      _ -> 5000
    end
  end

  defp docker_image do
    case Application.fetch_env(:code_runner, :docker_image) do
      {:ok, docker_image} -> docker_image
      _ -> "harfangk/elixir:latest"
    end
  end

  defp docker_memory do
    case Application.fetch_env(:code_runner, :docker_memory) do
      {:ok, docker_memory} -> docker_memory
      _ -> "50m"
    end
  end

  defp docker_args do
    [
      "run",
      "-i",
      "--rm",
      "-m", docker_memory(),
      "--memory-swap=-1",
      "--net=none",
      "--cap-drop=all",
      "--privileged=false",
      docker_image(),
      "elixir", "-e"
    ]
  end
end
