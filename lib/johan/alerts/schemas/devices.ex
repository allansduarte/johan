defmodule Johan.Alerts.Schemas.Devices do
  @moduledoc """
  Represents a device.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.HealthCenters
  alias Johan.Alerts.Schemas.Patients

  @required [:sim_sid, :health_centers_id, :patients_id]

  schema "devices" do
    field :sim_sid, :string

    belongs_to :health_centers, HealthCenters
    belongs_to :patients, Patients

    timestamps()
  end

  @doc "Changeset for creating a device"
  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
