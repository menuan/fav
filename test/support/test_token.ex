defmodule FirebaseAuthVerifier.TestToken do
  @moduledoc """
  A Tesla client used for fetching a token to verify in a test
  """

  use Tesla

  plug Tesla.Middleware.BaseUrl,
    "https://www.googleapis.com/identitytoolkit/v3/relyingparty"
  plug Tesla.Middleware.JSON

  def get_test_token([email: email, password: password]) do
    web_api_key = System.get_env("FIREBASE_WEB_API_KEY") || raise ArgumentError, "FIREBASE_WEB_API_KEY has not been set"
    body = %{
      email: email,
      password: password,
      returnSecureToken: true,
    }
    post("/verifyPassword?key=#{web_api_key}", body)
  end
end
