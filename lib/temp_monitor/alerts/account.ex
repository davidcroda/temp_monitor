defmodule TempMonitor.Alerts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :phone, :string
    field :notify, :boolean, default: true
    field :last_notified, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :phone, :notify, :last_notified])
    |> validate_required([:name, :phone])
    |> unique_constraint(:phone)
  end
end
