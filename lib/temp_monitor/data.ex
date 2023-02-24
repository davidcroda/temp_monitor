defmodule TempMonitor.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias TempMonitor.Repo

  alias TempMonitor.Data.Temperature

  require Logger

  def list_query(since \\ 60) do
    date_since = DateTime.add(DateTime.utc_now(), -1 * since, :minute)

    Temperature
    |> limit(^since)
    |> where([t], t.inserted_at > ^date_since)
    |> order_by(desc: :inserted_at)
  end

  @doc """
  Returns the list of temperatures.

  ## Examples

      iex> list_temperatures()
      [%Temperature{}, ...]

  """
  def list_temperatures(since \\ 60) do
    list_query(since)
    |> Repo.all()
  end

  def list_temperatures_for_graph(since \\ 60) do
    list_query(since)
    |> select([t], {t.inserted_at, t.temperature})
    |> Repo.all()
  end

  def average_temperatures(number \\ 5) do
    list_temperatures(number)
    |> Enum.map(& &1.temperature)
    |> Enum.sum()
    |> Kernel./(number)
  end

  @doc """
  Gets a single temperature.

  Raises `Ecto.NoResultsError` if the Temperature does not exist.

  ## Examples

      iex> get_temperature!(123)
      %Temperature{}

      iex> get_temperature!(456)
      ** (Ecto.NoResultsError)

  """
  def get_temperature!(id), do: Repo.get!(Temperature, id)

  @doc """
  Get the latest temperature reading.
  """
  def get_latest_temperature() do
    Temperature
    |> limit(1)
    |> order_by(desc: :inserted_at)
    |> Repo.one()
  end

  @doc """
  Creates a temperature.

  ## Examples

      iex> create_temperature(%{field: value})
      {:ok, %Temperature{}}

      iex> create_temperature(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_temperature(attrs \\ %{}) do
    %Temperature{}
    |> Temperature.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a temperature.

  ## Examples

      iex> update_temperature(temperature, %{field: new_value})
      {:ok, %Temperature{}}

      iex> update_temperature(temperature, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_temperature(%Temperature{} = temperature, attrs) do
    temperature
    |> Temperature.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a temperature.

  ## Examples

      iex> delete_temperature(temperature)
      {:ok, %Temperature{}}

      iex> delete_temperature(temperature)
      {:error, %Ecto.Changeset{}}

  """
  def delete_temperature(%Temperature{} = temperature) do
    Repo.delete(temperature)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking temperature changes.

  ## Examples

      iex> change_temperature(temperature)
      %Ecto.Changeset{data: %Temperature{}}

  """
  def change_temperature(%Temperature{} = temperature, attrs \\ %{}) do
    Temperature.changeset(temperature, attrs)
  end

  def prune_old_temperatures() do
    threshold = DateTime.add(DateTime.utc_now(), -6, :hour)

    {count, _} =
      Temperature
      |> where([t], t.inserted_at < ^threshold)
      |> Repo.delete_all()

    Logger.debug("Pruned #{count} records")
  end
end
