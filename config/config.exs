use Mix.Config

# Default configuration
config :firebase_auth_verifier,
  cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

# Import environment specific configuration
import_config "#{Mix.env()}.exs"
