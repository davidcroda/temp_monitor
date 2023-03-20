defmodule TempMonitorWeb.PageController do
  use TempMonitorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def deepSleep(conn, _params) do
    conn
    |> Plug.Conn.send_resp(200, [])
  end
end
