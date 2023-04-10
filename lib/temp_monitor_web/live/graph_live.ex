defmodule TempMonitorWeb.GraphLive do
  use TempMonitorWeb, :live_view

  alias Phoenix.PubSub
  alias TempMonitor.{Alerts, Config, Data}
  alias Contex.Plot

  require Logger

  @topic "readings"

  def mount(_params, _assigns, socket) do
    PubSub.subscribe(TempMonitor.PubSub, @topic)

    {:ok,
     socket
     |> assign(:temperature, Data.get_latest_temperature())
     |> assign(:current_view, "graph")
     |> filter_graph(5)}
  end

  defp filter_graph(socket, since) do
    socket
    |> assign(:temperatures, Data.list_temperatures_for_graph(since))
    |> build_chart()
  end

  defp build_chart(%{assigns: %{temperatures: []}} = socket) do
    assign(socket, :plot, raw("<h1 class='text-2xl'>No temperature data available</h1>"))
  end

  defp build_chart(%{assigns: %{temperatures: temperatures}} = socket) do
    chart =
      temperatures
      |> Contex.Dataset.new()
      |> Contex.LinePlot.new(colour_palette: :pastel)

    assign(
      socket,
      :plot,
      Plot.new(800, 600, chart)
      |> Plot.axis_labels("Time", "Temperature")
      |> Plot.to_svg()
    )
  end

  def handle_info(%{temperature: temperature}, socket) do
    dataPoint = {temperature.inserted_at, temperature.temperature}

    {:noreply,
     socket
     |> assign(:temperatures, [dataPoint | socket.assigns[:temperatures]])
     |> assign(:temperature, temperature)
     |> build_chart()}
  end

  def handle_event("filter_graph", %{"filter" => %{"since" => since}}, socket) do
    {since, _} = Integer.parse(since)
    {:noreply, filter_graph(socket, since)}
  end
end
