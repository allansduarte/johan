defmodule Johan.Notifications.Strategy do
  @moduledoc """
  Strategies are used to definy a base of actions do be done when
  determinated event occurs. They are created using `Ravenx` in
  strategies folder.

  We can create strategies for any set of actions we want execute.
  All of them should be declared on strategies folder.

  This module contains the definitions and the event_types that
  triggers the action call.
  """

  require Logger

  @patient_alert ["patient_alert"]

  @all_strategies_with_types [{"patient_alert", @patient_alert}]

  @doc "Returns a list with all strategies and its types"
  @spec all_strategies() :: list(String.t())
  def all_strategies, do: Enum.map(@all_strategies_with_types, &elem(&1, 0))
end
