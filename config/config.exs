# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank,
  ecto_repos: [Bank.Repo]

# Configures the endpoint
config :bank, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aCABqo/g1Npuh/WC4DUzBWGBSqWPlAC++DIf8gCd35CIlNQqbxnZjjJHPuO1h2t5",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bank.PubSub,
  live_view: [signing_salt: "zdw3GVWv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank, Bank.ElasticsearchCluster,
  url: "http://localhost:9200",
  username: nil,
  password: nil,
  api: Elasticsearch.API.HTTP,
  json_library: Jason,
  default_options: [
    timeout: 60_000,
    recv_timeout: 60_000
  ],
  indexes: %{
    accounts: %{
      settings: "priv/elasticsearch/accounts.json",
      store: Bank.ElasticsearchStore,
      sources: [Bank.Accounts.Account],
      bulk_page_size: 5000,
      bulk_wait_interval: 5_000
    }
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
