# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :availabit_web,
  namespace: AvailabitWeb,
  ecto_repos: [Availabit.Repo]

# Configures the endpoint
config :availabit_web, AvailabitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KNUN1S1GKB+wLm274Ra/PyLjbW3Uk/zrP6UxoRifDIxqmWeF4Hx0ZknNaZ7729Oa",
  render_errors: [view: AvailabitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AvailabitWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :availabit_web, :generators,
  context_app: :availabit

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "read:user,user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
