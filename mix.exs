defmodule FirebaseAuthVerifier.MixProject do
  use Mix.Project

  @app :firebase_auth_verifier
  @version Path.join(__DIR__, "VERSION")
    |> File.read!()
    |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "FirebaseAuthVerifier",
      description: description(),
      package: package(),
      source_url: "https://github.com/menuan/fav",
      homepage_url: "https://github.com/menuan/fav",
      docs: [
        main: "FirebaseAuthVerifier",
        extras: ["README.md"],
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {FirebaseAuthVerifier.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp description() do
    """
    A small library for verifying FirebaseAuth ID tokens.
    """
  end

  defp package() do
    [
      maintainers: ["Simon Bergström"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/menuan/fav"},
      files: files(),
    ]
  end

  defp files() do
    [
      "CHANGELOG.md",
      "LICENSE",
      "README.md",
      "VERSION",
      "lib",
      "mix.exs",
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "priv"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:joken, "~> 2.2"},
      {:jason, "~> 1.2"},

      # Tests
      {:junit_formatter, "~> 3.0", only: [:test]},
      {:mint, "~> 1.2", only: [:test]},
      {:castore, "~> 0.1", only: [:test]},
      {:hammox, "~> 0.2", only: [:test]},

      # dev
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end
end
