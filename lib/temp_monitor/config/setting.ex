defmodule TempMonitor.Config.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :key, :string
    field :value, :string
    field :type, :string, default: "string"

    timestamps()
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:key, :value, :type])
    |> validate_required([:key, :value])
    |> validate_inclusion(:type, ["string", "integer"])
    |> unique_constraint([:key])
  end
end
