defmodule FirebaseAuthVerifier do
  @moduledoc Keyword.fetch!(Mix.Project.config(), :description)

  alias FirebaseAuthVerifier.CertificateManager
  alias FirebaseAuthVerifier.SignerSource

  @doc """
  Verifies a JWT token, returning either `{:ok, claims}`, where `claims` is the decoded
  map of claims in the JWT, if it passes verification, or `{:error, term()}` if it does not.
  """
  @spec verify(binary(), non_neg_integer(), SignerSource.t())
    :: {:ok, %{required(binary()) => term()}} | {:error, term()}
  def verify(jwt, retries \\ 3, callback \\ CertificateManager)
  def verify(jwt, retries, callback) when is_integer(retries) and retries > 0 do
    verify_p(jwt, retries, callback)

  end
  def verify(_, _, _callback),
    do: {:error, :bad_arguments}

  defp verify_p(_jwt, 0, _callback),
    do: {:error, :timeout}
  defp verify_p(jwt, n, callback) when is_integer(n) do
    try do
      signers = callback.get_signers() |> Enum.map(fn {_key, v} -> v end)
      try_to_verify(jwt, signers)
    catch
      :exit, _reason ->
        verify_p(jwt, n - 1, callback)
    end
  end

  defp try_to_verify(_jwt, []), do: {:error, :no_valid_signer}
  defp try_to_verify(jwt, [signer|rest]) do
    case Joken.Signer.verify(jwt, signer) do
      {:ok, claims = %{"aud" => aud, "exp" => exp, "sub" => subject_id}} ->
        Logger.metadata(subject_id: subject_id)
        project_id = Application.get_env(:firebase_auth_verifier, :project_id) ||
          raise FirebaseAuthVerifier.ConfigurationError, message: "no project_id configured"
        res = exp
          |> DateTime.from_unix!()
          |> DateTime.diff(DateTime.utc_now())
        cond do
          res < 0 ->
            {:error, :expired_token}
          project_id != aud ->
            {:error, :invalid_aud}
          true ->
            {:ok, claims}
        end
      {:error, _reason} ->
        try_to_verify(jwt, rest)
    end
  end
end
