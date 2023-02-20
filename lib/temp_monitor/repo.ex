defmodule TempMonitor.Repo do
  use Ecto.Repo,
    otp_app: :temp_monitor,
    adapter: Ecto.Adapters.SQLite3
end
