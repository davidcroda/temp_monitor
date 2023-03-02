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

# K8S
  * Kubernetes deployment available in [`priv/k8s/service.yaml`](priv/k8s/service.yaml)
  * `kubectl create secret generic temp-monitor-secrets --from-literal="secret-key-base=SECRET_KEY_BASE"`
  * `kubectl create secret generic twilio --from-literal="account-sid=YOUR_ACCOUNT_SID" --from-literal="auth-token=YOUR_ACCOUNT_TOKEN"`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
