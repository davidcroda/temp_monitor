defmodule TempMonitor.Alerts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :phone, :string
    field :last_notified, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :phone, :last_notified])
    |> validate_required([:name, :phone])
    |> unique_constraint(:phone)
  end
end
