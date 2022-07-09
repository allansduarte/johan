defmodule Johan.Alerts.Schemas.HealthCenter do
  @moduledoc """
  Represents a health center.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.Caregivers
  alias Johan.Alerts.Schemas.Patients

  schema "health_centers" do
    field :name, :string

    has_many :caregivers, Caregivers
    has_many :patients, Patients

    timestamps()
  end

  @doc "Changeset for creating a health center"
  @spec changeset(health_center :: map(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(health_center \\ %__MODULE__{}, attrs) do
    health_center
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
