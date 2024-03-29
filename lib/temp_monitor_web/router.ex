defmodule TempMonitorWeb.Router do
  use TempMonitorWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {TempMonitorWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TempMonitorWeb do
    pipe_through(:browser)

    live_session :default do
      live("/", GraphLive)
      live("/settings", SettingsLive)
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", TempMonitorWeb do
    pipe_through(:api)

    resources("/temperatures", TemperatureController)
    resources("/accounts", AccountController)
    get("/deepSleep", PageController, :deepSleep)
    get("/settings", PageController, :settings)
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
