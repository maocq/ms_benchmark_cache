import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :fua, timezone: "America/Bogota"

config :fua,
  http_port: 8083,
  enable_server: true,
  secret_name_rds: "fua-dev-secretrds-CNX",
  secret_name: "fua-dev-secret-CNX",
  region: "us-east-1",
  token_exp: 600,
  version: "1.2.3"

config :ex_aws,
  region: "us-east-1",
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}, :instance_role],
  secret_access_key: [
    {:system, "AWS_SECRET_ACCESS_KEY"},
    {:awscli, "default", 30},
    :instance_role
  ]

config :logger,
  level: :debug
