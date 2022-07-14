defmodule Johan.Alerts.Inputs.AlertContent do
  @moduledoc """
  Input to validate the alert content.
  """

  use Johan.ValueObjectSchema

  alias Johan.Alerts.Schemas.Alerts

  @required [:created, :type, :value, :lat, :lon]

  embedded_schema do
    field :created, :naive_datetime_usec
    field :type, Ecto.Enum, values: Alerts.alerts_type()
    field :value, :string
    field :lat, :string
    field :lon, :string
  end

  @doc "Changeset for validate an alert content"
  @spec changeset(module :: map(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end


end
