defmodule TempMonitorWeb.PageController do
  use TempMonitorWeb, :controller

  alias TempMonitor.{Alerts, Data}

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
