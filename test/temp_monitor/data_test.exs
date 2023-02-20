defmodule TempMonitor.DataTest do
  use TempMonitor.DataCase

  alias TempMonitor.Data

  describe "temperatures" do
    alias TempMonitor.Data.Temperature

    import TempMonitor.DataFixtures

    @invalid_attrs %{humidity: nil, temperature: nil}

    test "list_temperatures/0 returns all temperatures" do
      temperature = temperature_fixture()
      assert Data.list_temperatures() == [temperature]
    end

    test "get_temperature!/1 returns the temperature with given id" do
      temperature = temperature_fixture()
      assert Data.get_temperature!(temperature.id) == temperature
    end

    test "create_temperature/1 with valid data creates a temperature" do
      valid_attrs = %{humidity: 120.5, temperature: 120.5}

      assert {:ok, %Temperature{} = temperature} = Data.create_temperature(valid_attrs)
      assert temperature.humidity == 120.5
      assert temperature.temperature == 120.5
    end

    test "create_temperature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_temperature(@invalid_attrs)
    end

    test "update_temperature/2 with valid data updates the temperature" do
      temperature = temperature_fixture()
      update_attrs = %{humidity: 456.7, temperature: 456.7}

      assert {:ok, %Temperature{} = temperature} =
               Data.update_temperature(temperature, update_attrs)

      assert temperature.humidity == 456.7
      assert temperature.temperature == 456.7
    end

    test "update_temperature/2 with invalid data returns error changeset" do
      temperature = temperature_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_temperature(temperature, @invalid_attrs)
      assert temperature == Data.get_temperature!(temperature.id)
    end

    test "delete_temperature/1 deletes the temperature" do
      temperature = temperature_fixture()
      assert {:ok, %Temperature{}} = Data.delete_temperature(temperature)
      assert_raise Ecto.NoResultsError, fn -> Data.get_temperature!(temperature.id) end
    end

    test "change_temperature/1 returns a temperature changeset" do
      temperature = temperature_fixture()
      assert %Ecto.Changeset{} = Data.change_temperature(temperature)
    end
  end
end
