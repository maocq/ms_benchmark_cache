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

config :fua,
  dbname: "FUA_DB",
  username: "postgres",
  password: "!QAZxsw2#EDC",
  host: "127.0.0.1",
  port: 5432,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  db_schema: "schemfua"

config :fua,
  redis_host: "localhost",
  redis_port: "6379"

config :fua, ecto_repos: [Fua.Adapters.Repositories.Repo]

config :fua,
       auth_host: "fua-authentication",
       auth_port: 80,
       auth_gen_ca_endpoint: "/generate-authorization-code"

config :fua,
       openshift_host: "session-manager-sessionmanager-sa.apps.ocpdev.ambientesbc.lab",
       openshift_port: 443,
       openshift_validate_session_endpoint: "/security/api/session/validate"

config :fua,
  session_cache: Fua.Adapters.Cache.SessionCache,
  authorization_code_cache: Fua.Adapters.AuthorizationCode.AuthorizationCodeCache,
  consumer_repository: Fua.Adapters.Repositories.ConsumerGateway,
  delegate_session_repository: Fua.Adapters.Repositories.DelegateSessionGateway,
  auth_client: Fua.Adapters.Auth.AuthClient,
  session_broker: Fua.Adapters.Broker.RabbitMQ,
  session_client: Fua.Adapters.Session.SessionClient

config :fua,
  mq_application_name: "mq_application_name",
  mq_url: "mq_url",
  mq_user: "mq_user",
  mq_pass: "mq_pass",
  mq_protocol: "mq_protocol",
  mq_max_retries: 3
