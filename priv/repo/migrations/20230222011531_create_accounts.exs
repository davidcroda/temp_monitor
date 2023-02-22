defmodule TempMonitor.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :phone, :string
      add :last_notified, :utc_datetime, null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:phone])
  end
end
