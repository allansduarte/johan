defmodule Johan.Alerts do
  @moduledoc """
  Alerts context
  """

  alias Johan.Alerts.Commands.CreateAlert

  @doc "See `Johan.Alerts.Commands.CreateAlert.execute/1`"
  defdelegate create(input), to: CreateAlert, as: :execute
end
