defmodule TempMonitor.Alerts do
  @moduledoc """
  The Alerts context.
  """

  import Ecto.Query, warn: false
  require Logger

  alias TempMonitor.Repo

  alias TempMonitor.Alerts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  def list_accounts_not_notified(since_seconds) do
    now = NaiveDateTime.utc_now()

    query =
      from a in Account,
        where: ^now - a.last_notified > ^since_seconds,
        or_where: is_nil(a.last_notified),
        select: a

    Repo.all(query)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def set_last_notification(%Account{} = account, last_notified \\ NaiveDateTime.utc_now()) do
    account
    |> change_account(%{last_notified: last_notified})
    |> Repo.update!()
  end

  def notify_all(message) do
    list_accounts_not_notified(3600)
    |> Enum.each(&send_notification(&1, message))
  end

  def send_notification(%Account{} = account, message) do
    Logger.debug("send_notification: #{inspect(account)}, #{message}")

    case ExTwilio.Message.create(
           to: account.phone,
           from: "+18447530112",
           body: "#{account.name}: #{message}"
         ) do
      {:ok, _} -> set_last_notification(account)
      {:error, error, _} -> Logger.error("Error sending notification: #{inspect(error)}")
    end
  end
end
