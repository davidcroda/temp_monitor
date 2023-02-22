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

TempMonitor.Repo.insert!(%TempMonitor.Alerts.Account{
  name: "Dad",
  phone: "+15558675309"
})
