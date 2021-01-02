use Mix.Config

# JUnit formatter configuration
config :junit_formatter,
  report_file: "test_report.xml",
  report_dir: "./test-results",
  print_report_file: true,
  prepend_project_name?: true

# Configure Tesla for the tests
config :tesla,
  adapter: Tesla.Adapter.Mint
