defmodule JohanWeb.ChangesetView do
  use JohanWeb, :view

  alias Ecto.Changeset

  @doc """
  Traverses and translates changeset errors.
  See `Ecto.Changeset.traverse_errors/2`
  for more details.
  """
  @spec translate_errors(map()) :: map()
  def translate_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end

  @spec render(String.t(), map()) :: map()
  def render("changeset_error.json", %{type: type, reason: reason, errors: errors}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      type: type,
      reason: reason,
      errors: Enum.map(errors, &translate_errors(&1))
    }
  end

  @spec render(String.t(), map()) :: map()
  def render("changeset_error.json", %{type: type, reason: reason, changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      type: type,
      reason: reason,
      errors: [translate_errors(changeset)]
    }
  end
end
