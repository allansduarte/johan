defmodule Johan.ChangesetToExchema do
  @moduledoc """
  Converts changeset errors to exchema

  This allows migration of API's from Exchema to Ecto.Schema without breaking changes.
  Unfortunately a 1 to 1 conversion is not possible, due to different behaviors from Ecto.
  These cases are minor and listed below:
    - Empty string is not valid as a required field in Ecto, but is allowed in Exchema.
      We return :missing in this case.
    - Some types are present in Ecto, but not in Exchema. E.g.: decimal, id, ...
      In this case, we chose the type in Exchema that fits better.

  Changeset invalid changes can be annotated with the option exchema_error the value will be used
  in the error output. This allows to customize the error of a custom validator.
  """

  alias Ecto.Changeset

  @doc "Translate changeset errors to exchema errors format"
  @spec translate_errors(Changeset.t()) :: [{atom(), atom(), atom(), atom()}]
  def translate_errors(%Changeset{changes: changes, errors: errors}, current_level \\ []) do
    errors = translate_field_errors(errors, current_level)

    nested_errors = translate_nested_errors(changes, current_level)

    errors ++ nested_errors
  end

  defp translate_nested_errors(changes, current_level) do
    Enum.flat_map(changes, fn
      # embeds_one
      {key, %Changeset{} = inner} -> translate_errors(inner, current_level ++ [key])
      # embeds_many
      {key, inner} when is_list(inner) -> translate_nested_errors(inner, current_level ++ [key])
      %Changeset{} = change -> translate_errors(change, current_level)
      _ -> []
    end)
  end

  defp translate_field_errors(errors, current_level) do
    Enum.map(errors, fn {field, error} ->
      case error do
        {_message, error_opts} ->
          translate_field_error(field, error_opts, current_level)

        {_message} ->
          translate_field_error(field, [], current_level)
      end
    end)
  end

  defp translate_field_error(field, error_opts, current_level) do
    {current_level ++ [field], :exchema_type, :exchema_predicate, translate_reason(error_opts)}
  end

  defp translate_reason(error_opts) do
    exchema_error = Keyword.get(error_opts, :exchema_error)
    validation_error = Keyword.get(error_opts, :validation)

    cond do
      exchema_error ->
        exchema_error

      validation_error == :cast ->
        translate_cast_type_error(Keyword.get(error_opts, :type))

      validation_error == :required ->
        # Ecto.Changeset has no other option when validation_error is required
        # so we can't fully convert from Exchema to Changeset
        :missing

      validation_error == :inclusion ->
        :invalid

      true ->
        :invalid
    end
  end

  # these types don't exist in Exchema
  defp translate_cast_type_error(:binary_id), do: :not_a_binary
  defp translate_cast_type_error(:id), do: :not_a_binary
  defp translate_cast_type_error(:decimal), do: :not_a_float

  defp translate_cast_type_error(:float), do: :not_a_float
  defp translate_cast_type_error(:integer), do: :not_an_integer
  defp translate_cast_type_error(:map), do: :not_list_or_map
  defp translate_cast_type_error({:map, _}), do: :not_list_or_map
  defp translate_cast_type_error(:string), do: :not_a_binary
  defp translate_cast_type_error({:array, _}), do: :not_a_list
  defp translate_cast_type_error(_), do: :invalid
end
