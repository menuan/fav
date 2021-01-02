defmodule FirebaseAuthVerifier.CertificateManager do
  @moduledoc """
  A SourceSigner that caches the [`Joken.Signer(s)`](`Joken.Signer`) according to
  the max-age of the cache header of the response.

  Done according to:
  https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
  """

  use GenServer

  @type t :: __MODULE__

  @behaviour FirebaseAuthVerifier.SignerSource

  @doc "Starts and links the application"
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, [name: __MODULE__])
  end

  @doc """
  Get the `Joken.Signer`s built from Google's signing certificate(s),
  returned as a map with the ID as the key.
  """
  @impl true
  def get_signers(timeout \\ Application.get_env(:firebase_auth_verifier, :verify_timeout, 2_500))
  def get_signers(timeout) do
    GenServer.call(__MODULE__, :get_signers, timeout)
  end

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:get_signers, _from, state) do
    new_state = get_signers_p(state)
    {:reply, new_state.signers, new_state}
  end

  # get_signers_p/1
  defp get_signers_p(state = %{signers: _signers, expires_at: expires_at}) do
    get_signers_p(System.monotonic_time(:second) > expires_at, state)
  end
  defp get_signers_p(%{}),
    do: get_signers_p(true, %{})

  # get_signers_p/2
  defp get_signers_p(false, state),
    do: state
  defp get_signers_p(true, state) when is_map(state) do
    update_state(state, rebuild_signers())
  end

  defp update_state(state, {signers, expires_at}) do
    state
    |> Map.put(:signers, signers)
    |> Map.put(:expires_at, expires_at)
  end

  defp rebuild_signers do
    case FirebaseAuthVerifier.Client.get_certificates() do
      {:ok, %Tesla.Env{body: body, headers: headers}} ->
        {map_certificates_to_signers(body), System.monotonic_time() + extract_max_age(headers)}
      {:error, reason} ->
        raise FirebaseAuthVerifier.ConfigurationError, message: inspect(reason)
    end
  end

  defp map_certificates_to_signers(body) do
    body
    |> Enum.map(&cert_tuple_to_jwk/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(%{}, fn {k, v}, a -> Map.put(a, k, v) end)
  end

  defp cert_tuple_to_jwk({key, value}) do
    try do
      signer = Joken.Signer.create("RS256", %{"pem" => value})
      {key, signer}
    rescue
      _ ->
        nil
    end
  end

  defp extract_max_age(headers) do
    header = "cache-control"
    case List.keyfind(headers, header, 0, nil) do
      nil -> nil
      {^header, value} ->
        Regex.named_captures(~r/.*max-age=(?<age>[0-9]+)/, value)
        |> Map.fetch!("age")
        |> Integer.parse()
        |> elem(0)
    end
  end
end
