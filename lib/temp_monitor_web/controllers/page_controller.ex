defmodule TempMonitorWeb.PageController do
  use TempMonitorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def graph(conn, _params) do
    temp = TempMonitor.Data.get_latest_temperature()
    render(conn, "graph.html", %{temp: temp})
  end
end
