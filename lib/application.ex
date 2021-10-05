defmodule Fua.Application do
  @moduledoc """
  Documentation for `MsControllerFk`.
  """
  alias Fua.Config.{AppConfig, ConfigHolder}
  alias Fua.EntryPoint.User.UserController
  alias Fua.Helpers.CustomTelemetry
  alias Fua.DrivenAdapters.Redis.Redis
  alias Fua.DrivenAdapters.Secrets.SecretManagerAdapter

  use Application
  require Logger

  def start(_type, _args) do
    config = AppConfig.load_config()
    in_test? = Application.fetch_env(:fua, :in_test)
    children = with_plug_server(config) ++ application_children(in_test?)

    CustomTelemetry.custom_telemetry_events()

    opts = [strategy: :one_for_one, name: Fua.Supervisor]
    Supervisor.start_link(children, opts)

  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.info("Configure Http server in port #{inspect(port)}")

    [
      {
        Plug.Cowboy,
        scheme: :http,
        plug: UserController,
        options: [
          port: port
        ]
      }
    ]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def application_children({:ok, true} = _test_env),
    do: [
      {ConfigHolder, AppConfig.load_config()}
    ]

  def application_children(_other_env),
    do: [
      {ConfigHolder, AppConfig.load_config()},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]},
      {SecretManagerAdapter, []},
      #{Repo, []},
      {Redis, []},
      #{RabbitMQ, []},
      #{Fua.Adapters.Repositories.ConsumerEtsManager, []},
      #{Fua.Adapters.Repositories.DelegateSessionEtsManager, []}
    ]
end
