defmodule TempMonitor.ConfigFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TempMonitor.Config` context.
  """

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        key: "some key",
        value: "some value"
      })
      |> TempMonitor.Config.create_setting()

    setting
  end
end
