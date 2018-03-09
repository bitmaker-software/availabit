use Mix.Config

# Configure your database
config :availabit, Availabit.Repo,
  adapter: Sqlite.Ecto2,
  database: "test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox
