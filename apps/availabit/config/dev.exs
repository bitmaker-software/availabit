use Mix.Config

# Configure your database
config :availabit, Availabit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "availabit_dev",
  hostname: "localhost",
  pool_size: 10
