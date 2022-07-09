defmodule Johan.Alerts.Schemas.Caregivers do
  @moduledoc """
  Represents a caregiver.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.HealthCenter

  schema "caregivers" do
    field :phone_number, :string
    belongs_to :health_center, HealthCenter

    timestamps()
  end

   @doc "Changeset for creating a caregiver"
   @spec changeset(caregiver :: map(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(caregiver \\ %__MODULE__{}, attrs) do
    caregiver
    |> cast(attrs, [:phone_number, :health_center_id])
    |> validate_required([:phone_number, :health_center_id])
  end
end
