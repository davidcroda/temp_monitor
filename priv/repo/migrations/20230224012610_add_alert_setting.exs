defmodule TempMonitor.Repo.Migrations.AddAlertSetting do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :notify, :boolean, default: true
    end
  end
end
