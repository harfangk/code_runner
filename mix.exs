defmodule CodeRunner.Mixfile do
  use Mix.Project

  def project do
    [app: :code_runner,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "A module for running Elixir code in sandbox environment",
     package: package(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {CodeRunner.Application, []}]
  end

  defp deps do
    [
      {:porcelain, "~> 2.0"},
      {:poolboy, "~> 1.5"},
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev]},
    ]
  end

  defp package do
    [maintainers: ["Bonghyun Kim"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/harfangk/code_runner"}]
  end
end
