defmodule CodeRunnerTest do
  use ExUnit.Case, async: true
  doctest CodeRunner

  test "executing valid Elixir code should return proper output" do
    code = "2+3"
    assert CodeRunner.run(code) == "5\n"
  end

  test "executing invalid Elixir code returns proper error message" do
    code = "IO.puts()"
    result = CodeRunner.run(code)
    assert String.match?(result, ~r/(UndefinedFunctionError)/)
  end

  test "each code should compile and run independent of one another" do
    code1 =
      """
      defmodule Hello do
        def hello() do
          3+5
        end
      end
      Hello.hello()
      """
    assert CodeRunner.run(code1) == "8\n"
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

    concurrent_task_start_time = :os.timestamp()

    [1, 2]
    |> Enum.map(fn(_) -> Task.async(fn -> CodeRunner.run("Process.sleep(100)") end) end)
    |> Enum.map(fn(task) -> Task.await(task, :infinity) end)

    concurrent_task_end_time = :os.timestamp()
    concurrent_elapsed_time = :timer.now_diff(concurrent_task_end_time, concurrent_task_start_time)


    sequential_task_start_time = :os.timestamp()

    [1, 2]
    |> Enum.each(fn(_) -> CodeRunner.run("Process.sleep(100)") end) 

    sequential_task_end_time = :os.timestamp()
    sequential_elapsed_time = :timer.now_diff(sequential_task_end_time, sequential_task_start_time)

    assert concurrent_elapsed_time < sequential_elapsed_time * 0.75
  end
end
