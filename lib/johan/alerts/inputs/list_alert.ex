defmodule Johan.Alerts.Inputs.ListAlert do
  @moduledoc """
  Input to list alerts.
  """

  use Johan.ValueObjectSchema

  import Johan.Queries.Filter, only: [parse_filter: 2]

  alias Johan.Alerts.Schemas.Alerts

  @optional [:page_size, :page]
  @possible_filters [
    :type,
    :created_at_start,
    :created_at_end
  ]

  embedded_schema do
    field :page_size, :integer
    field :page, :integer

    embeds_one :filter, Filter, primary_key: false do
      field :type, Ecto.Enum, values: Alerts.alerts_type()
      field :created_at_start, :naive_datetime_usec
      field :created_at_end, :naive_datetime_usec
    end
  end

  @doc "Changeset for validate alert payload"
  @spec changeset(model :: map(), params :: map()) :: Ecto.Changeset.t()
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @optional)
    |> parse_filter(:filter)
    |> cast_embed(:filter, with: &filter_changeset/2)
  end

  @doc "Converts the given input to an `Ecto.Query`"
  @spec to_query(input :: __MODULE__.t()) :: Ecto.Query.t()
  def to_query(%__MODULE__{filter: filters}) do
    (filters || %{})
    |> to_map()
    |> Enum.map(&convert_to_filter/1)
    |> Alerts.query()
  end

  defp filter_changeset(model, params), do: cast(model, params, @possible_filters)

  defp convert_to_filter(filter), do: filter
end
