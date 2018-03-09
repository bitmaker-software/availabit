use Mix.Config

config :availabit, ecto_repos: [Availabit.Repo]

import_config "#{Mix.env}.exs"
