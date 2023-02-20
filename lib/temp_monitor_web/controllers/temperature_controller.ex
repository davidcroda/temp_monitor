defmodule TempMonitorWeb.TemperatureController do
  use TempMonitorWeb, :controller

  alias TempMonitor.Data
  alias TempMonitor.Data.Temperature

  action_fallback TempMonitorWeb.FallbackController

  def index(conn, _params) do
    temperatures = Data.list_temperatures()
    render(conn, "index.json", temperatures: temperatures)
  end

  def create(conn, temperature_params) do
    with {:ok, %Temperature{} = temperature} <- Data.create_temperature(temperature_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.temperature_path(conn, :show, temperature))
      |> render("show.json", temperature: temperature)
    end
  end

  def show(conn, %{"id" => id}) do
    temperature = Data.get_temperature!(id)
    render(conn, "show.json", temperature: temperature)
  end

  def update(conn, %{"id" => id, "temperature" => temperature_params}) do
    temperature = Data.get_temperature!(id)

    with {:ok, %Temperature{} = temperature} <-
           Data.update_temperature(temperature, temperature_params) do
      render(conn, "show.json", temperature: temperature)
    end
  end

  def delete(conn, %{"id" => id}) do
    temperature = Data.get_temperature!(id)

    with {:ok, %Temperature{}} <- Data.delete_temperature(temperature) do
      send_resp(conn, :no_content, "")
    end
  end
end
