# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TempMonitor.Repo.insert!(%TempMonitor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

TempMonitor.Repo.insert(
  %TempMonitor.Alerts.Account{
    name: "Dad",
    phone: "+15558675309"
  },
  on_conflict: :nothing
)

for n <- 1..1000 do
  TempMonitor.Repo.insert!(%TempMonitor.Data.Temperature{
    temperature: :rand.uniform(70) / 1,
    inserted_at: DateTime.truncate(DateTime.add(DateTime.utc_now(), -1 * n, :minute), :second)
  })
end
