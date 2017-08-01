defmodule CodeRunnerTest do
  use ExUnit.Case, async: true
  doctest CodeRunner

  test "executing valid Elixir code returns proper output" do
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

  test "code should timeout when it runs longer than the timeout duration set in config" do
    sleep_duration = Application.fetch_env!(:code_runner, :timeout) + 1000
    code = "Process.sleep(#{sleep_duration})"
    result = CodeRunner.run(code)
    assert String.match?(result, ~r/timeout/)
  end
end
