defmodule Johan.Alerts.Schemas.Devices do
  @moduledoc """
  Represents a device.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.HealthCenter
  alias Johan.Alerts.Schemas.Patient

  @required [:sim_sid, :health_center_id, :patient_id]

  schema "devices" do
    field :sim_sid, :string

    belongs_to :health_center, HealthCenter
    belongs_to :patient, Patient

    timestamps()
  end

  @doc "Changeset for creating a device"
  @spec changeset(device :: map(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(device \\ %__MODULE__{}, attrs) do
    device
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
