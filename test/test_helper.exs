ExUnit.configure(
  exclude: [:skip],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter]
)
ExUnit.start()
