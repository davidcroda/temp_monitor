defmodule TempMonitorWeb.TemperatureView do
  use TempMonitorWeb, :view
  alias TempMonitorWeb.TemperatureView

  def render("index.json", %{temperatures: temperatures}) do
    %{data: render_many(temperatures, TemperatureView, "temperature.json")}
  end

  def render("show.json", %{temperature: temperature}) do
    %{data: render_one(temperature, TemperatureView, "temperature.json")}
  end

  def render("temperature.json", %{temperature: temperature}) do
    %{
      id: temperature.id,
      temperature: temperature.temperature,
      humidity: temperature.humidity,
      inserted_at: DateTime.from_naive!(temperature.inserted_at, "America/New_York")
    }
  end
end
