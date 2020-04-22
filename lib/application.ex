defmodule FirebaseAuthVerifier.Application do
  @moduledoc false

  use Application

  require Logger

  @doc false
  def start(_type, _args) do
    children = [
      FirebaseAuthVerifier.CertificateManager
    ]
    opts = [strategy: :one_for_one, name: FirebaseAuthVerifier.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
