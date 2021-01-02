# Changelog of FirebaseAuthVerifier

## 0.2.0

* Removed runtime dependency on `:hackney`, it is up to the consumer to choose the dependency and the corresponding adapter.
* Removed default config to use the hackney adapter.
* Only install `:mint`, `:ca_store` and `:hammox` for the test environment.

## 0.1.0

First version. Features included are:

* Fetches certificates from the following URL, according to [Verifyng ID tokens with custom JWT libraries](https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library)
  [Google APIs - Certificate Source](https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com)
* Caches the certificate according to the `Cache-Control` header's `max-age`, where if it has expired on the next verification it requests the certificate again.
* `FirebaseAuthVerifier.verify/3` will try to get a valid certificate three times, by default, but this can be changed by passing an integer as a second argument.
* Validates that the AUD claim of the JWT corresponds to the `project_id` configuration
