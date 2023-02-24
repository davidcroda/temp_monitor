defmodule TempMonitor.Data.Temperature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "temperatures" do
    field :humidity, :float
    field :temperature, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(temperature, attrs) do
    temperature
    |> cast(attrs, [:temperature, :humidity, :inserted_at])
    |> validate_required([:temperature])
  end
end
