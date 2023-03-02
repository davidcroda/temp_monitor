defmodule TempMonitor.AlertsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TempMonitor.Alerts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone: "some phone"
      })
      |> TempMonitor.Alerts.create_account()

    account
  end
end
