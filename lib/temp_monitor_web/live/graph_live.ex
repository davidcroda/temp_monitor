defmodule TempMonitorWeb.GraphLive do
  use TempMonitorWeb, :live_view

  alias TempMonitor.{Alerts, Data}
  alias Contex.Plot

  def mount(_params, _assigns, socket) do
    temperature = Data.get_latest_temperature()
    accounts = Alerts.list_accounts()

    chart =
      Data.list_temperatures_for_graph()
      |> Contex.Dataset.new()
      |> Contex.LinePlot.new()

    plot =
      Plot.new(800, 600, chart)
      |> Plot.axis_labels("Time", "Temperature")
      |> Plot.to_svg()

    {:ok,
     socket
     |> assign(:temperature, temperature)
     |> assign(:accounts, accounts)
     |> assign(:plot, plot)}
  end
end
