defmodule Wechat.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wechat,
      version: "0.4.2",
      elixir: "~> 1.6",
      elixirc_options: [warnings_as_errors: true],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),

      # Publish package
      name: "Wechat",
      package: package(),
      docs: docs()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger, :xmerl],
      mod: {Wechat.Application, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:plug, "~> 1.8"},
      {:redix, ">= 0.0.0", optional: true},
      {:bypass, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description, do: "Wechat API wrapper in Elixir."

  defp package do
    [
      name: :wechat,
      licenses: ["MIT"],
      exclude_patterns: [".DS_Store"],
      maintainers: ["goofansu"],
      links: %{"Github" => "https://github.com/elixir-wechat/wechat"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
