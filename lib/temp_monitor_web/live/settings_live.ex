defmodule TempMonitorWeb.SettingsLive do
  alias TempMonitor.Alerts
  alias TempMonitor.Config
  use TempMonitorWeb, :live_view

  require Logger

  def mount(_params, _assigns, socket) do
    {:ok,
     socket
     |> assign(:current_view, "settings")
     |> assign(:settings, Config.list_settings())
     |> assign(:accounts, Alerts.list_accounts())}
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

  def handle_event("update_setting", %{"key" => key, "value" => value}, socket) do
    Logger.debug("Setting #{key}: #{value}")

    settings =
      with setting = Config.get_setting!(key),
           {:ok, setting} <- Config.update_setting(setting, %{value: value}),
           {:ok, settings} <- Map.fetch(socket.assigns, :settings) do
        Enum.map(settings, fn s ->
          case s.key do
            ^key ->
              setting

            _ ->
              s
          end
        end)
      else
        :error -> Map.fetch(socket.assigns, :settings)
      end

    {:noreply, assign(socket, :settings, settings)}
  end
end
