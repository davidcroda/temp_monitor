defmodule TempMonitorWeb.PageController do
  use TempMonitorWeb, :controller
  alias TempMonitor.Config

  action_fallback(TempMonitorWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def deepSleep(conn, _params) do
    status =
      case Config.get_value!("deepSleep") do
        1 -> 200
        _ -> 400
      end

    Plug.Conn.send_resp(conn, status, [])
  end

  def settings(conn, _params) do
    settings = Config.list_settings()
    render(conn, "settings.json", settings: settings)
  end
end
