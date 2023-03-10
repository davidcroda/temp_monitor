defmodule TempMonitor.Repo.Migrations.CreateTemperatures do
  use Ecto.Migration

  def change do
    create table(:temperatures) do
      add :temperature, :float
      add :humidity, :float, null: true

      timestamps(type: :utc_datetime)
    end
  end
end
