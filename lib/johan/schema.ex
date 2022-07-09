defmodule Johan.Schema do
  @moduledoc """
  Models a queryable schema.

  It should be used in order to inject common schema atributes and modules.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @type t() :: %__MODULE__{}

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
