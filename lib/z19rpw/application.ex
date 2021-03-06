defmodule Z19rpw.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      {Cluster.Supervisor, [topologies, [name: Z19rpw.ClusterSupervisor]]},
      Z19rpw.MnesiaClusterSupervisor,
      # Start the Ecto repository
      Z19rpw.Repo,
      # Start the Telemetry supervisor
      Z19rpwWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Z19rpw.PubSub},
      # Start the Endpoint (http/https)
      Z19rpwWeb.Endpoint
      # Start a worker by calling: Z19rpw.Worker.start_link(arg)
      # {Z19rpw.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Z19rpw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Z19rpwWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
