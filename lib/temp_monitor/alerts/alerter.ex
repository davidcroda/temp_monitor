defmodule TempMonitor.Alerts.Alerter do
  use GenServer
  require Logger
  alias TempMonitor.Data
  alias TempMonitor.Alerts

  @max_time_threshold 600
  @max_average_temperature 5
  @check_interval 60_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :check_temps, @check_interval)
  end

  def validate_current(temperature) do
    diff =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.diff(temperature)

    valid = diff < @max_time_threshold

    if !valid do
      Alerts.notify_all("Last freezer temperature reading [#{diff}] seconds ago!")
    end

    valid
  end

  def validate_temperature(average_temperature) do
    valid = average_temperature < @max_average_temperature

    if !valid do
      Alerts.notify_all(
        "Freezer average temperature [#{average_temperature}] greater than threshold [#{@max_average_temperature}]!"
      )
    end

    valid
  end

  def handle_info(:check_temps, state) do
    current =
      Data.get_latest_temperature()
      |> Map.fetch!(:inserted_at)
      |> validate_current

    average_temp =
      Data.average_temperatures(5)
      |> Float.floor(2)

    valid_temp = validate_temperature(average_temp)

    Logger.info(
      "Temp Current: #{current}, Average Temp: #{average_temp}, Valid Temp: #{valid_temp}"
    )

    schedule_work()

    {:noreply, state}
  end
end
