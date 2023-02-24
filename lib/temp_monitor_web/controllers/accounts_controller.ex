defmodule TempMonitorWeb.AccountController do
  use TempMonitorWeb, :controller

  alias TempMonitor.Alerts
  alias TempMonitor.Alerts.Account

  def index(conn, _params) do
    render(conn, "index.json", accounts: Alerts.list_accounts())
  end

  def create(conn, account_params) do
    with {:ok, %Account{} = account} <- Alerts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", account: Alerts.get_account!(id))
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Alerts.get_account!(id)

    with {:ok, %Account{} = account} <-
           Alerts.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Alerts.get_account!(id)

    with {:ok, %Account{}} <- Alerts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
