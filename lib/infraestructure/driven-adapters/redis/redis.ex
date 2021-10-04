defmodule Fua.DrivenAdapters.Redis.Redis do
  @moduledoc """
    Adapter in charge of consulting the redis database
  """
  use GenServer
  alias Fua.DrivenAdapters.Secrets.SecretManagerAdapter

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    %{
        redis_host: redis_host,
        redis_port: redis_port
    } = SecretManagerAdapter.get_secret()
    Redix.start_link(host: redis_host, port: String.to_integer(redis_port), name: :redix)
  end

  def health() do
    with "PONG" <- Redix.command!(:redix, ["PING"]) do
      {:ok, true}
    else
      error -> {:error, error}
    end
  end

end
