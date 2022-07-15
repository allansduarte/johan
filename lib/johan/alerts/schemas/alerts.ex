defmodule Johan.Alerts.Schemas.Alerts do
  @moduledoc """
  Represents an alert.
  """

  use Johan.Schema
  use Johan.Query

  alias Johan.Alerts.Schemas.Patients

  @type alert_type :: :BPM | :FALL | :TEMP

  @required [:created, :type, :value, :lat, :lon, :patients_id, :metadata]
  @alert_type [:BPM, :FALL, :TEMP]

  schema "alerts" do
    field :created, :naive_datetime_usec
    field :type, Ecto.Enum, values: @alert_type
    field :value, :string
    field :lat, :string
    field :lon, :string
    field :metadata, :map

    belongs_to :patients, Patients
  end

   @doc "Changeset for creating an alert"
   @spec changeset(module :: Alerts.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end

  @doc "Existing alert types and supported combinations of them"
  @spec alerts_type() :: list(alert_type())
  def alerts_type, do: @alert_type
end
