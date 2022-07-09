defmodule Johan.Alerts.Schemas.Patients do
  @moduledoc """
  Represents a patient.
  """

  use Johan.Schema

  alias Johan.Alerts.Schemas.Device
  alias Johan.Alerts.Schemas.HealthCenter

  @required [:first_name, :last_name]
  @optional [:metadata]

  schema "patients" do
    field :first_name, :string
    field :last_name, :string
    field :metadata, :map

    embeds_many :addresses, Address, primary_key: false do
      field :street, :string
      field :number, :string
    end

    belongs_to :health_center, HealthCenter
    has_many :devices, Device

    timestamps()
  end

  @doc "Changeset for creating a patient"
  @spec changeset(patient :: map(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(patient \\ %__MODULE__{}, attrs) do
    patient
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_embed(:addresses, with: &changeset_address/2, required: true)
  end

  defp changeset_address(address, attrs) do
    address
    |> cast(attrs, [:street, :number])
    |> validate_required([:street, :number])
  end
end
