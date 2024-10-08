defmodule Shapex.MixProject do
  use Mix.Project

  def project do
    [
      app: :shapex,
      version: "0.3.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/ilyabayel/shapex"
    ]
  end

  defp description do
    "Shapex is a library for validating data structures in Elixir."
  end

  defp package do
    [
      name: "shapex",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/ilyabayel/shapex"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
