defmodule Fua.Helpers.CustomTelemetry do
  alias Fua.Utils.DataTypeUtils
  import Telemetry.Metrics

  def custom_telemetry_events() do
    :telemetry.attach(
      "fua-ecto",
      [:fua, :adapters, :repositories, :repo, :query],
      &handle_custom_event/4,
      nil
    )

    :telemetry.attach("fua-plug-stop", [:fua, :plug, :stop], &handle_custom_event/4, nil)
    :telemetry.attach("fua-redis-stop", [:redix, :pipeline, :stop], &handle_custom_event/4, nil)
  end

  def execute_custom_event(object, operation, value) do
    :telemetry.execute([:fua, object], %{"#{operation}": value}, %{})
  end

  def execute_custom_event(object, operation, value, metadata) do
    :telemetry.execute([:fua, object], %{"#{operation}": value}, metadata)
  end

  defp handle_custom_event([:fua, :adapters, :repositories, :repo, :query], measures, metadata, _) do
    :telemetry.execute(
      [:fua, :db, :query],
      %{total_time: DataTypeUtils.system_time_to_milliseconds(measures.total_time)},
      %{source: metadata.source}
    )
  end

  defp handle_custom_event([:fua, :plug, :stop], measures, metadata, _) do
    :telemetry.execute(
      [:fua, :http_request],
      %{duration: DataTypeUtils.monolotic_time_to_milliseconds(measures.duration)},
      %{path: metadata.conn.private.plug_route}
    )
  end

  defp handle_custom_event([:redix, :pipeline, :stop], measures, metadata, _) do
    :telemetry.execute(
      [:fua, :redis_request],
      %{duration: DataTypeUtils.monolotic_time_to_milliseconds(measures.duration)},
      %{commands: metadata.commands}
    )
  end

  def metrics do
    [
      # Openshift
      sum("fua.openshift.http_call", tags: [:service]),
      counter("fua.openshift.http_call", tags: [:service]),

      # Plug Metrics
      sum("fua.http_request.duration", tags: [:path]),
      counter("fua.http_request.duration", tags: [:path]),

      # Ecto
      sum("fua.db.query.total_time", tags: [:source]),
      counter("fua.db.query.total_time", tags: [:source]),

      # Redis
      sum("fua.redis_request.duration", tags: [:commands]),
      counter("fua.redis_request.duration", tags: [:commands]),

      # Rabbit
      counter("async.message.completed.duration.count",
        event_name: "async.message.completed",
        measurement: "duration",
        tags: [:transaction, :result]
      ),
      sum("async.message.completed.duration", tags: [:transaction, :result]),

      # VM Metrics
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      sum("vm.total_run_queue_lengths.total"),
      sum("vm.total_run_queue_lengths.cpu"),
      sum("vm.total_run_queue_lengths.io")
    ]
  end
end
