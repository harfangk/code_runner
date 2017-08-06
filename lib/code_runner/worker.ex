defmodule CodeRunner.Worker do
  use GenServer

  @timeout Application.fetch_env!(:code_runner, :timeout)
  @docker_args [
    "run",
    "-i",
    "--rm",
    "-m", "50m",
    "--memory-swap=-1",
    "--net=none",
    "--cap-drop=all",
    "--privileged=false",
    Application.get_env(:code_runner, :docker_image),
    "elixir",
    "-e"
  ]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:run_code, code}, _from, state) do
    process = Porcelain.spawn("docker", @docker_args ++ ["#{code} |> IO.inspect()"], err: :out)

    result = Porcelain.Process.await(process, @timeout)

    case result do
      {:ok, %Porcelain.Result{out: output}} ->
        {:reply, output, state}
      {:error, :timeout} ->
        Porcelain.Process.stop(process)
        {:reply, "Code took longer than #{@timeout}ms to run, resulting in timeout.", state}
    end
  end
end
