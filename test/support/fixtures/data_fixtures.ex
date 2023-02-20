defmodule TempMonitor.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TempMonitor.Data` context.
  """

  @doc """
  Generate a temperature.
  """
  def temperature_fixture(attrs \\ %{}) do
    {:ok, temperature} =
      attrs
      |> Enum.into(%{
        humidity: 120.5,
        temperature: 120.5
      })
      |> TempMonitor.Data.create_temperature()

    temperature
  end
end
