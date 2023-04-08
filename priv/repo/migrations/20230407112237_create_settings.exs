defmodule TempMonitor.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :key, :string
      add :value, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:settings, [:key])

    execute(fn ->
      repo().query!(
        "INSERT INTO settings (key, value, type, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5)",
        ["deepSleep", "0", "integer", NaiveDateTime.utc_now(), NaiveDateTime.utc_now()]
      )
    end)

    execute(fn ->
      repo().query!(
        "INSERT INTO settings (key, value, type, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5)",
        ["interval", "60", "integer", NaiveDateTime.utc_now(), NaiveDateTime.utc_now()]
      )
    end)
  end
end
