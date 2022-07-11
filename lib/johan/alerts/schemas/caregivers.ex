defmodule Johan.Alerts.Schemas.Caregivers do
  @moduledoc """
  Represents a caregiver.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.HealthCenters

  @required [:phone_number, :health_centers_id]

  schema "caregivers" do
    field :phone_number, :string
    belongs_to :health_centers, HealthCenters

    timestamps()
  end

   @doc "Changeset for creating a caregiver"
   @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
