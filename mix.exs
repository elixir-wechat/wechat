defmodule Wechat.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wechat,
      version: "0.2.2",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:exvcr, "~> 0.8", only: :test},
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:floki, "~> 0.17.0"},
      {:plug, "~> 1.0"}
    ]
  end

  defp description do
    """
    Wechat API wrapper in Elixir.
    """
  end

  defp package do
    [
      name: :wechat,
      licenses: ["MIT"],
      maintainers: ["goofansu"],
      links: %{"Github" => "https://github.com/goofansu/wechat-elixir"}
    ]
  end
end
