defmodule FirebaseAuthVerifier.VerificationTest do
  use ExUnit.Case, async: true

  alias FirebaseAuthVerifier.SignerSource
  alias FirebaseAuthVerifier.TestToken

  import Hammox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "FirebaseAuthVerifier returns error on timeout" do
    defmock(SignerSourceMock, for: SignerSource)
    expect(SignerSourceMock, :get_signers, 3, fn -> exit(:timeout) end)

    assert {:error, :timeout} = FirebaseAuthVerifier.verify("does not matter", 3, SignerSourceMock)
  end

  test "test invalid AUD verification (wrong project_id for the given api_key, helpful if you have more projects and want to separate)" do
    Application.put_env(:firebase_auth_verifier, :project_id, "some incorrect project id")
    email = System.get_env("TEST_USER_EMAIL") || raise ArgumentError, "TEST_USER_EMAIL has not been set"
    pass = System.get_env("TEST_USER_PASSWORD") || raise ArgumentError, "TEST_USER_PASSWORD has not been set"

    {:ok, body = %{"idToken" => id_token}} = TestToken.get_test_token(email: email, password: pass)

    assert %{"email" => ^email, "localId" => subject, "idToken" => ^id_token} = body
    assert {:error, :invalid_aud} = FirebaseAuthVerifier.verify(id_token)
  end

  test "fetch an ID token from Firebase and verify it - expecting verification to pass" do
    Application.put_env(:firebase_auth_verifier, :project_id, System.get_env("TEST_PROJECT_ID"))
    email = System.get_env("TEST_USER_EMAIL") || raise ArgumentError, "TEST_USER_EMAIL has not been set"
    pass = System.get_env("TEST_USER_PASSWORD") || raise ArgumentError, "TEST_USER_PASSWORD has not been set"

    {:ok, body = %{"idToken" => id_token}} = TestToken.get_test_token(email: email, password: pass)

    assert %{"email" => ^email, "localId" => subject, "idToken" => ^id_token} = body
    assert {:ok, %{"sub" => ^subject}} = FirebaseAuthVerifier.verify(id_token)
  end
end
