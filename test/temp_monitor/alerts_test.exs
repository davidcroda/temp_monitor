defmodule TempMonitor.AlertsTest do
  use TempMonitor.DataCase

  alias TempMonitor.Alerts

  describe "accounts" do
    alias TempMonitor.Alerts.Account

    import TempMonitor.AlertsFixtures

    @invalid_attrs %{name: nil, phone: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Alerts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Alerts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{name: "some name", phone: "some phone"}

      assert {:ok, %Account{} = account} = Alerts.create_account(valid_attrs)
      assert account.name == "some name"
      assert account.phone == "some phone"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Alerts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{name: "some updated name", phone: "some updated phone"}

      assert {:ok, %Account{} = account} = Alerts.update_account(account, update_attrs)
      assert account.name == "some updated name"
      assert account.phone == "some updated phone"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Alerts.update_account(account, @invalid_attrs)
      assert account == Alerts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Alerts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Alerts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Alerts.change_account(account)
    end
  end
end
