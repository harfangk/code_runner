defmodule CodeRunnerTest do
  use ExUnit.Case
  doctest CodeRunner

  test "Executing valid Elixir code returns proper output" do
    code = "IO.puts(:hello)"
    assert CodeRunner.run(code) == "hello\n"
  end

  test "executing invalid Elixir code returns proper error message" do
    code = "IO.puts()"
    assert CodeRunner.run(code) == "** (UndefinedFunctionError) function IO.puts/0 is undefined or private. Did you mean one of:\n\n      * puts/1\n      * puts/2\n\n    (elixir) IO.puts()\n    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6\n    (elixir) lib/code.ex:170: Code.eval_string/3\n\n"
  end

  # Unit tests
  ~s{
    it compiles each time the code is sent. 
    creates a docker container to isolate each compilation environment
    creating docker container is a process external to BEAM
    use Porcelain to handle external process
    supervision
    main supervisor manages coderunner process
    coderunner process spawns a new process each time it receives code to execute
    executor process returns either output or error message
    executor process times out and terminates after a given amount of time
    does docker process 

    2. take code and executes it
      2-1. should remember the source that sent the code
        code
        code-runner process for each code execution
        code-runner process will be the external interface
      2-2. should compile and run the code in an isolated env
        create a docker container each time the code is run
      2-3. should terminate the code within the given amount of time
        Process.send_after/3
    3. should send the result back to the source, be it output, error, or timeout
      caller process 
  }
end
