defmodule PhoenixLiveMeta.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/yourusername/phoenix_live_meta"

  def project do
    [
      app: :phoenix_live_meta,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Dynamic meta tag management for Phoenix LiveView applications"
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
      {:phoenix_live_view, "~> 0.20.0"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:styler, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Your Name"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib LICENSE.md mix.exs README.md)
    ]
  end
end
