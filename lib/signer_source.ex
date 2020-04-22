defmodule FirebaseAuthVerifier.SignerSource do
  @moduledoc "The behaviour of a SignerSource"

  @doc """
  Expects to return a map with the `Joken.Signer`'s ID as a key.

  NOTE: This is what is returned by Google and for now I do not know
  if it's necessary to do it this way, so it might change in
  the future.
  """
  @callback get_signers() :: %{required(binary()) => Joken.Signer.t()} | {:error, term()}
end
