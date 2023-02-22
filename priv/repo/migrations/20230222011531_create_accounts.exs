defmodule TempMonitor.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :phone, :string
      add :last_notified, :naive_datetime, null: true

      timestamps()
    end

    create unique_index(:accounts, [:phone])
  end
end
