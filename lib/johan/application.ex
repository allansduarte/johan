defmodule Johan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Johan.Repo,
      # Start the Telemetry supervisor
      JohanWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Johan.PubSub},
      # Start the Endpoint (http/https)
      JohanWeb.Endpoint,
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Johan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JohanWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do # Add this line
    Application.fetch_env!(:johan, Oban)
  end
end
