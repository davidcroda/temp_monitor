defmodule TempMonitor.Data.Temperature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "temperatures" do
    field :humidity, :float
    field :temperature, :float

    timestamps()
  end

  @doc false
  def changeset(temperature, attrs) do
    temperature
    |> cast(attrs, [:temperature, :humidity])
    |> validate_required([:temperature])
  end
end
