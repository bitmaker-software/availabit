use Mix.Config

# Configure your database
config :availabit, Availabit.Repo,
  adapter: Sqlite.Ecto2,
  database: "dev.sqlite3"
