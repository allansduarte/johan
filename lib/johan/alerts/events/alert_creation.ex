defmodule Johan.Alerts.Events.AlertCreation do
  @moduledoc """
  Input to validate the alert content.
  """

  use Johan.ValueObjectSchema

  @required [:device, :alert_content, :input]

  embedded_schema do
    field :device, :map
    field :alert_content, :map
    field :input, :map
  end

  @doc "Changeset for validate an alert content"
  @spec changeset(module :: map(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end

  @doc "Topic for this event to be published"
  @spec topic() :: String.t()
  def topic, do: config()[:topics_to_produce][:requested]

  defp config, do: Application.get_env(:johan, PandaCore.Accounts.Events)
end
