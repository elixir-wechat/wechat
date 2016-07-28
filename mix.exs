defmodule Wechat.Mixfile do
  use Mix.Project

  def project do
    [app: :wechat,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:plug, "~> 1.0"},
     {:poison, "~> 2.0"},
     {:httpoison, "~> 0.9.0"},
     {:floki, "~> 0.9.0"}]
  end

  defp description do
    """
    Wechat API wrapper.
    """
  end

  defp package do
    [
      name: :wechat,
      licenses: ["MIT"],
      maintainers: ["goofansu"],
      links: %{"Github" => "https://github.com/goofansu/wechat_elixir"}
    ]
  end
end
