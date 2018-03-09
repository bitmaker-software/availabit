use Mix.Config

# Configure your database
config :availabit, Availabit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "availabit_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
