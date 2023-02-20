defmodule Mix.Tasks.Docker.Build do
  @moduledoc "Build the deployment docker container"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.shell().cmd("docker build . -t davidcroda/temp_monitor:latest")
  end
end

defmodule Mix.Tasks.Docker.Push do
  @moduledoc "Push the deployment docker container to dockerhub"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.shell().cmd("docker push davidcroda/temp_monitor:latest")
  end
end
