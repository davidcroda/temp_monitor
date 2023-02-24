defmodule TempMonitorWeb.PageController do
  use TempMonitorWeb, :controller

  alias TempMonitor.{Alerts, Data}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def graph(conn, _params) do
    temperature = Data.get_latest_temperature()
    accounts = Alerts.list_accounts()
    render(conn, "graph.html", %{temperature: temperature, accounts: accounts})
  end
end
