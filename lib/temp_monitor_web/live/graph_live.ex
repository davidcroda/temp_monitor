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
