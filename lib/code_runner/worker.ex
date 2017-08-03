defmodule CodeRunner.Worker do
  use GenServer

  @timeout Application.fetch_env!(:code_runner, :timeout)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:run_code, code}, _from, state) do
    process = Porcelain.spawn("elixir", ["-e", "#{code} |> IO.inspect()"], err: :out)

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
