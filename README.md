# TempMonitor

Simple phoenix backend to accept incoming temperature readings from an ESP8266 with a DHT22 temperature sensor
in my basement chest freezer. Sends SMS notifications if no readings within a 5 minute span or if the average
temperature over 10 minutes rises above 10 degrees fahrenheit.

Uses 'Context Charts](https://contex-charts.org/) to generate graphs server side and displays in a Phoenix
LiveView.

# Setup

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
