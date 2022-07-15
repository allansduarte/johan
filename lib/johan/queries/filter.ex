defmodule Johan.Queries.Filter do
  @moduledoc """
  Filter is a query parameter we receive as a JSON object.
  """

  alias Ecto.Changeset

  @doc """
  Add the decoded filters to the changeset params.

  If the given field value (filters) is not a valid encoded JSON object it
  invalidates the changeset.
  """
  @spec parse_filter(params :: Changeset.t(), field :: atom()) :: Changeset.t()
  def parse_filter(%Changeset{params: params} = changeset, field)
      when is_atom(field) and not is_nil(params) do
    stringified_field = Atom.to_string(field)

    params
    |> Map.get(stringified_field)
    |> decode_filter()
    |> case do
      {:ok, %{} = filters} ->
        new_params = Map.put(params, stringified_field, filters)
        %{changeset | params: new_params}

      _ ->
        new_params = Map.put(params, stringified_field, %{})

        changeset
        |> Map.put(:params, new_params)
        |> Changeset.add_error(field, "is invalid")
    end
  end

  def parse_filter(%Changeset{} = changeset, field) when is_atom(field),
    do: Changeset.add_error(changeset, field, "is invalid")

  defp decode_filter(nil), do: {:ok, %{}}
  defp decode_filter(filter) when is_binary(filter), do: Jason.decode(filter)
  defp decode_filter(filter) when is_map(filter), do: {:ok, filter}
  defp decode_filter(_), do: {:error, :invalid_filter}
end
