defmodule MsControllerFk.MixProject do
  use Mix.Project

  def project do
    [
      app: :fua,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:lager, :logger, :amqp],
      mod: {Fua.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:postgrex, "~> 0.15.0"},
      {:uuid, "~> 1.1"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_dynamo, "~> 4.0"},
      {:ex_aws_sts, "~> 2.0"},
      {:ex_aws_secretsmanager, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.7.0"},
      {:configparser_ex, "~> 4.0"},
      {:distillery, "~> 2.1"},
      {:plug_cowboy, "~> 2.2"},
      {:cors_plug, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.2"},
      {:castore, "~> 0.1.0"},
      {:murmur, "~> 1.0"},
      {:junit_formatter, "~> 3.1", only: [:test]},
      {:mock, "~> 0.3.0", only: :test},
      {:fnv1a, "~> 0.1.0", only: :dev},
      {:fnv, "~> 0.3.2", only: :dev},
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:redix, "~> 1.0"},
      {:mint, "~> 1.0"},
      {:reactive_commons, "~> 0.6.1"},
      {:telemetry_metrics_prometheus, "~> 1.0"},
      {:telemetry_poller, "~> 0.5.1"},
      {:tzdata, "~> 1.1"},
      {:calendar, "~> 1.0.0"},
      {:timex, "~> 3.0"},
      {:credo_sonarqube, "~> 0.1.0"},
      {:sobelow, "~> 0.8",only: :dev},
      {:dialyxir, "~> 0.4", only: :dev}
    ]
  end
end
