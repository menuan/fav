defmodule FirebaseAuthVerifier.Client do
  use Tesla

  @moduledoc """
  A simple Tesla client to request the signing certificate that
  will be used to verify the signature.
  """

  plug Tesla.Middleware.BaseUrl,
    Application.get_env(:firebase_auth_verifier, :cert_url) || raise "Base URL has not been set for FirebaseAuthVerifier"
  plug Tesla.Middleware.JSON

  def get_certificates do
    get("/")
  end
end
