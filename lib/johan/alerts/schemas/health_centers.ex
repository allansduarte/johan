defmodule Johan.Alerts.Schemas.HealthCenters do
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
  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
