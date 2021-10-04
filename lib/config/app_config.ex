defmodule Fua.Config.AppConfig do
  defstruct [
    :timezone,
    :http_port,
    :enable_server,
    :secret_name_rds,
    :secret_name,
    :region,
    :token_exp,
    :version,
    :redis_host,
    :redis_port
  ]

  def load_config do
    %__MODULE__{
      timezone: load(:timezone),
      http_port: load(:http_port),
      enable_server: load(:enable_server),
      secret_name_rds: load(:secret_name_rds),
      secret_name: load(:secret_name),
      region: load(:region),
      token_exp: load(:token_exp),
      version: load(:version),
      redis_host: load(:redis_host),
      redis_port: load(:redis_port)
    }
  end

  defp load(property_name), do: Application.fetch_env!(:fua, property_name)
end
