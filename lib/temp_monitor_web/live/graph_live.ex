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
     |> assign(:accounts, Alerts.list_accounts())
     |> assign(:settings, Config.list_settings())
     |> filter_graph()}
  end

  defp filter_graph(socket, since \\ 60) do
    socket
    |> assign(:temperatures, Data.list_temperatures_for_graph(since))
    |> build_chart()
  end

  defp build_chart(socket) do
    temperatures = Map.fetch!(socket.assigns, :temperatures)

    case length(temperatures) do
      0 ->
        assign(socket, :plot, raw("<h1 class='text-2xl'>No temperature data available</h1>"))

      _ ->
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

  def handle_event("update_setting", %{"key" => key, "value" => value}, socket) do
    Logger.debug("Setting #{key}: #{value}")

    Config.get_setting!(key)
    |> Config.update_setting(%{value: value})

    {:noreply, socket}
  end

  def handle_event("toggle_notify", %{"account" => id}, socket) do
    account = Alerts.get_account!(id)
    {:ok, account} = Alerts.update_account(account, %{notify: !account.notify})

    {:noreply,
     assign(
       socket,
       :accounts,
       socket.assigns[:accounts]
       |> Enum.map(fn a ->
         case a.id == account.id do
           true -> account
           false -> a
         end
       end)
     )}
  end
end
