defmodule MetaHeexComponent.MixProject do
  use Mix.Project

  @version "0.2.2"
  @source_url "https://github.com/e-fu/meta_heex_component.git"

  def project do
    [
      app: :meta_heex_component,
      version: @version,
      elixir: "~> 1.14",
      phoenix: "~> 1.7.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Dynamic meta tag management for Phoenix LiveView and Controller applications"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:styler, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["e.fu"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib LICENSE.md mix.exs README.md),
      build_tools: ["mix"],
      extra: %{
        "type" => "library",
        "documentation" => "https://hexdocs.pm/meta_heex_component"
      }
    ]
  end
end
