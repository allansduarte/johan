defmodule Johan.Alerts.Inputs.Alert do
  @moduledoc """
  Input to create an alert.
  """

  use Johan.ValueObjectSchema

  @required [:status, :api_version, :sim_sid, :direction, :content]
  @statuses [:received]
  @api_versions [:v1]

  embedded_schema do
    field :status, Ecto.Enum, values: @statuses
    field :api_version, Ecto.Enum, values: @api_versions
    field :sim_sid, :string
    field :direction, :string
    field :content, :string
  end

  @doc "Changeset for validate alert payload"
  @spec changeset(module :: map(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
