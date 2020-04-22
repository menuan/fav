# FirebaseAuthVerifier

A simple Elixir library for fetching the signing certificate for
FirebaseAuth's ID tokens, following the documentation of
[Verify ID tokens using a third party JWT library](https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be
installed by adding `firebase_auth_verifier` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:firebase_auth_verifier, "~> 0.1.0"}
  ]
end
```

## Configuration

### Required configuration(s)

```elixir
# configure the endpoint to GET certificate from and the timeout of the FirebaseAuthVerifier.verify/3 call
config :firebase_auth_verifier,
  cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com",
  verify_timeout: 2_500
```

With the default retry count of `3`, this means a request could halt
for up to `7500` ms, given that the endpoint does not return within
this time when the local cache has gone stale. So set your
`verify_timeout` to something tolerable for your case.

### Optional configuration(s)

```elixir
# configure an adapter for Tesla
config :tesla,
  adapter: Tesla.Adapter.Hackney
```

NOTE: `cert_url` might be inlined in a future release if it is deemed
pointless to have it as a configuration, as it is not very likely to
change. It could however prove useful for testing if one wants to mock
the Firebase/Google endpoint.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/firebase_auth_verifier](https://hexdocs.pm/firebase_auth_verifier).

## To investigate

Feature scope for the version 0.2.0:

1. Investigate whether setting up a timer for the `max-age` check
   rather than letting it go stale can prevent timeouts

## How to contribute

If you want to contribute, either by reporting an issue or by fixing a
known issue, just create a GitHub issue at [FirebaseAuthVerifier
Issues](https://github.com/menuan/fav/issues) detailing the problem. 

Then you can either solve it and create a pull request, or I will take
a look at it as soon as possible. It is of course possible to help out
with any other issues found there, if one wants to.

### Testing your branch

When contributing to this project and running tests, the following ENV
variables are currently required for one of the integration tests:

* FIREBASE\_WEB\_API\_KEY
* TEST\_USER\_EMAIL
* TEST\_USER\_PASSWORD
* TEST\_PROJECT\_ID

See `example.test.env` as a way to source these variables when running
local tests through `env $(cat .env) mix test`, as an example.

So this requires a Firebase project to be set up with a pre-made
email-password user for testing.

Just make sure not to commit such files if you do decide to make a PR.
