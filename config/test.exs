import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :johan, Johan.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "johan_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :johan, JohanWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BYfAwldXCMdgJBiUzhIkhziZsgrdHqA/7OSqBSSZqpqIOvdR/Yrxf10lcprZFZMT",
  server: false

# In test we don't send emails.
config :johan, Johan.Mailer, adapter: Swoosh.Adapters.Test

# Oban config
config :johan, Oban, queues: false, plugins: false

# Print only warnings and errors during test
config :logger, backends: [], level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
