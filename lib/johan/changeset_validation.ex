defmodule Johan.ChangesetValidation do
  @moduledoc """
  Helper functions to work with changeset validations.
  """

  alias Ecto.Changeset
  alias Johan.{ChangesetToExchema, ValueObjectSchema}

  @typedoc "All possible changeset responses"
  @type changeset_response :: {:ok, Ecto.Schema.t()} | {:error, Changeset.t()}

  @doc "Cast and apply the given changeset and params into a struct"
  @spec cast_and_apply(schema :: module(), params :: map() | struct()) :: changeset_response()
  def cast_and_apply(schema, params, opts \\ [])

  def cast_and_apply(schema, %{__struct__: _} = params, opts) when is_atom(schema) do
    cast_and_apply(schema, ValueObjectSchema.to_map(params), opts)
  end

  def cast_and_apply(schema, params, opts) when is_atom(schema) and is_map(params) do
    %{}
    |> schema.__struct__()
    |> schema.changeset(params)
    |> case do
      %{valid?: true} = changeset ->
        {:ok, Changeset.apply_changes(changeset)}

      changeset ->
        if Keyword.get(opts, :exchema_errors, false) do
          {:error, ChangesetToExchema.translate_errors(changeset)}
        else
          {:error, changeset}
        end
    end
  end
end
