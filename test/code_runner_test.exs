defmodule CodeRunnerTest do
  use ExUnit.Case, async: true
  doctest CodeRunner

  test "executing valid Elixir code should return proper output" do
    code = "IO.puts(:hello)"
    assert CodeRunner.run(code) == "hello\n"
  end

  test "executing invalid Elixir code returns proper error message" do
    code = "IO.puts()"
    result = CodeRunner.run(code)
    assert String.match?(result, ~r/(UndefinedFunctionError)/)
  end

  test "each code should compile and run independent of one another" do
    code1 = "defmodule Hello do; def hello() do; IO.puts(:hello); end; end; Hello.hello()"
    assert CodeRunner.run(code1) == "hello\n"
    code2 = "Hello.hello()"
    result = CodeRunner.run(code2)
    assert String.match?(result, ~r/(UndefinedFunctionError)/)
  end

  test "code should result in timeout when it runs longer than the timeout duration set in the configuration" do
    sleep_duration = Application.fetch_env!(:code_runner, :timeout) + 200
    code = "Process.sleep(#{sleep_duration})"
    result = CodeRunner.run(code)
    assert String.match?(result, ~r/timeout/)
  end

  test "codes should run concurrently and take less time than they would have taken when run sequentially" do
    pool_size = Application.fetch_env!(:code_runner, :pool_size)
    pool_overflow = Application.fetch_env!(:code_runner, :pool_overflow)
    task_size = Enum.min([5, pool_size + pool_overflow])

    task_start_time = :os.timestamp()

    1..task_size
    |> Enum.map(fn(_) -> Task.async(fn -> CodeRunner.run("Process.sleep(100)") end) end)
    |> Enum.map(fn(task) -> Task.await(task, :infinity) end)

    task_end_time = :os.timestamp()

    elapsed_time = :timer.now_diff(task_end_time, task_start_time)

    assert elapsed_time < task_size * 100_000
  end
end
