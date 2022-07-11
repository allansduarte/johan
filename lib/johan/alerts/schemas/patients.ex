defmodule Johan.Alerts.Schemas.Patients do
  @moduledoc """
  Represents a patient.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.Devices
  alias Johan.Alerts.Schemas.HealthCenters

  @required [:first_name, :last_name, :health_centers_id]
  @optional [:metadata]

  schema "patients" do
    field :first_name, :string
    field :last_name, :string
    field :metadata, :map

    embeds_many :addresses, Address, primary_key: false do
      field :street, :string
      field :number, :integer
    end

    belongs_to :health_centers, HealthCenters
    has_many :devices, Devices

    timestamps()
  end

  @doc "Changeset for creating a patient"
  @spec changeset(patient :: map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> cast_embed(:addresses, with: &changeset_address/2, required: true)
  end

  defp changeset_address(module, params) do
    module
    |> cast(params, [:street, :number])
    |> validate_required([:street, :number])
  end
end
