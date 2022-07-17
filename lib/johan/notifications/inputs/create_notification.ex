defmodule Johan.Notifications.Inputs.CreateNotification do
  @moduledoc """
  Input for create notification
  """

  use Johan.ValueObjectSchema

  alias Johan.Notifications.Strategy

  @required [:event, :data]
  @optional []

  embedded_schema do
    field :event, :string
    field :data, :map
  end

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_inclusion(:event, Strategy.all_strategies())
  end
end
