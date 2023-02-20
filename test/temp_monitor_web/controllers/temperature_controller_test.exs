defmodule TempMonitorWeb.TemperatureControllerTest do
  use TempMonitorWeb.ConnCase

  import TempMonitor.DataFixtures

  alias TempMonitor.Data.Temperature

  @create_attrs %{
    humidity: 120.5,
    temperature: 120.5
  }
  @update_attrs %{
    humidity: 456.7,
    temperature: 456.7
  }
  @invalid_attrs %{humidity: nil, temperature: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all temperatures", %{conn: conn} do
      conn = get(conn, Routes.temperature_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create temperature" do
    test "renders temperature when data is valid", %{conn: conn} do
      conn = post(conn, Routes.temperature_path(conn, :create), temperature: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.temperature_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "humidity" => 120.5,
               "temperature" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.temperature_path(conn, :create), temperature: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update temperature" do
    setup [:create_temperature]

    test "renders temperature when data is valid", %{
      conn: conn,
      temperature: %Temperature{id: id} = temperature
    } do
      conn =
        put(conn, Routes.temperature_path(conn, :update, temperature), temperature: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.temperature_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "humidity" => 456.7,
               "temperature" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, temperature: temperature} do
      conn =
        put(conn, Routes.temperature_path(conn, :update, temperature), temperature: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete temperature" do
    setup [:create_temperature]

    test "deletes chosen temperature", %{conn: conn, temperature: temperature} do
      conn = delete(conn, Routes.temperature_path(conn, :delete, temperature))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.temperature_path(conn, :show, temperature))
      end
    end
  end

  defp create_temperature(_) do
    temperature = temperature_fixture()
    %{temperature: temperature}
  end
end
