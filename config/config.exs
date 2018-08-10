# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :slackproject, Slackproject.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "slackproject_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

  # config :slackproject,
  #   ecto_repos: [Slackproject.User, Slackproject.Payload]

  #added
  #config :slackproject, incoming_slack_webhook: "https://hooks.slack.com/services/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"
  
  #added
  config :slackproject, :url, "https://hooks.slack.com/services/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"

  config :ssl, protocol_version: :"tlsv1.2"
  # General application configuration
  config :slackproject,
    ecto_repos: [Slackproject.Repo]

    # Configures the endpoint
  config :slackproject, SlackprojectWeb.Endpoint,
    url: [host: "localhost"],
    secret_key_base: "x4wyV+pORWr7TUmP0NBQ/0q1Q52xmJ0MUbsT+Bgu/BffMQjlTcQ2t3KBgjtrVESy",
    render_errors: [view: SlackprojectWeb.ErrorView, accepts: ~w(html json)],
    pubsub: [name: Slackproject.PubSub,
             adapter: Phoenix.PubSub.PG2]

  #config :slack, :web_http_client, Slackproject.CustomClient
  # Configures Elixir's Logger
  config :logger, :console,
    format: "$time $metadata[$level] $message\n",
    metadata: [:user_id]

  # Import environment specific config. This must remain at the bottom
  # of this file so it overrides the configuration defined above.
  import_config "#{Mix.env}.exs"
