defmodule TempMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TempMonitor.Repo,
      # Start the Telemetry supervisor
      TempMonitorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TempMonitor.PubSub},
      # Start the Endpoint (http/https)
      TempMonitorWeb.Endpoint,
      # Start a worker by calling: TempMonitor.Worker.start_link(arg)
      # {TempMonitor.Worker, arg}
      TempMonitor.Alerter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TempMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TempMonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
