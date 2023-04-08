defmodule TempMonitorWeb.PageView do
  use TempMonitorWeb, :view

  def render("settings.json", %{settings: settings}) do
    Enum.into(settings, %{}, &{&1.key, &1.value})
  end

  def render("setting.json", %{setting: setting}) do
    %{
      key: setting.key,
      value: setting.value,
      type: setting.type
    }
  end
end
