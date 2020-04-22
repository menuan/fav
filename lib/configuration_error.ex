defmodule FirebaseAuthVerifier.ConfigurationError do
  @moduledoc "Thrown if there is a misconfiguration. See docs for configuration steps"
  defexception message: "unknown configuration error"
end
