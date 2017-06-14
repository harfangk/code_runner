defmodule CodeRunnerTest do
  use ExUnit.Case
  doctest CodeRunner

  test "executing valid Elixir code returns proper output" do
    code = "IO.puts(:hello)"
    assert CodeRunner.run(code) == "hello\n"
  end

  test "executing invalid Elixir code returns proper error message" do
    code = "IO.puts()"
    assert CodeRunner.run(code) == "** (UndefinedFunctionError) function IO.puts/0 is undefined or private. Did you mean one of:\n\n      * puts/1\n      * puts/2\n\n    (elixir) IO.puts()\n    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6\n    (elixir) lib/code.ex:170: Code.eval_string/3\n\n"
  end

  test "each code should compile and run in isolated environment" do
    code1 = "defmodule Hello do; def hello() do; IO.puts(:hello); end; end; Hello.hello()"
    assert CodeRunner.run(code1) == "hello\n"
    code2 = "Hello.hello()"
    assert CodeRunner.run(code2) == "** (UndefinedFunctionError) function Hello.hello/0 is undefined (module Hello is not available)\n    Hello.hello()\n    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6\n    (elixir) lib/code.ex:170: Code.eval_string/3\n\n"
  end

  @tag :skip
  test "code should timeout when it takes longer than configuration timeout time" do
    code = Process.sleep(6000)
    assert CodeRunner.run(code) == :timeout
  end
end
