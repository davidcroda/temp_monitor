defmodule TempMonitorWeb.GraphLive do
  use TempMonitorWeb, :live_view

  alias Phoenix.PubSub
  alias TempMonitor.{Alerts, Data}
  alias Contex.Plot

  require Logger

  @topic "readings"

  def mount(_params, _assigns, socket) do
    PubSub.subscribe(TempMonitor.PubSub, @topic)

    {:ok,
     socket
     |> assign(:temperatures, Data.list_temperatures_for_graph())
     |> assign(:temperature, Data.get_latest_temperature())
     |> assign(:accounts, Alerts.list_accounts())
     |> build_chart()}
  end

  defp build_chart(socket) do
    chart =
      Map.fetch!(socket.assigns, :temperatures)
      |> Contex.Dataset.new()
      |> Contex.LinePlot.new()

    assign(
      socket,
      :plot,
      Plot.new(800, 600, chart)
      |> Plot.axis_labels("Time", "Temperature")
      |> Plot.to_svg()
    )
  end

  def handle_info(%{topic: @topic, payload: %{temperature: temperature}}, socket) do
    dataPoint = {temperature.inserted_at, temperature.temperature}
    assign(socket, :temperatures, [dataPoint | socket.assigns[:temperatures]])
  end
end
