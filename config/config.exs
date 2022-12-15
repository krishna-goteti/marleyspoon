# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :marleyspoon, MarleyspoonWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MarleyspoonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Marleyspoon.PubSub,
  live_view: [signing_salt: "5R0rOdA/"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Tesla adapter as Hackney
config :tesla, adapter: Tesla.Adapter.Hackney

config :marleyspoon, :content_api_client, Marleyspoon.Clients.ContentDeliveryAPI

config :marleyspoon,
       :content_api_url,
       System.get_env("CONTENT_API_URL", "https://cdn.contentful.com")

config :marleyspoon, :content_api_config,
  space_id: System.get_env("SPACE_ID", "kk2bw5ojx476"),
  environment_id: System.get_env("ENVIRONMENT_ID", "master"),
  access_token:
    System.get_env(
      "ACCESS_TOKEN",
      "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c"
    ),
  content_type: System.get_env("CONTENT_TYPE", "recipe")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
