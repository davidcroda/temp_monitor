defmodule TempMonitor.ConfigTest do
  use TempMonitor.DataCase

  alias TempMonitor.Config

  describe "settings" do
    alias TempMonitor.Config.Setting

    import TempMonitor.ConfigFixtures

    @invalid_attrs %{key: nil, value: nil}

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Config.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Config.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      valid_attrs = %{key: "some key", value: "some value"}

      assert {:ok, %Setting{} = setting} = Config.create_setting(valid_attrs)
      assert setting.key == "some key"
      assert setting.value == "some value"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Config.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      update_attrs = %{key: "some updated key", value: "some updated value"}

      assert {:ok, %Setting{} = setting} = Config.update_setting(setting, update_attrs)
      assert setting.key == "some updated key"
      assert setting.value == "some updated value"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Config.update_setting(setting, @invalid_attrs)
      assert setting == Config.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Config.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Config.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Config.change_setting(setting)
    end
  end
end
