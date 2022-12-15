import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :marleyspoon, MarleyspoonWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "t6aPX+AyGlUui51mScf0iVdlaqHJA3KZB/euAYUYPEyy0gBhUW3R4CqW+88/LY5J",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :tesla, adapter: Tesla.Mock

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
