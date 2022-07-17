defmodule Johan.Notifications.StrategyBehaviour do
  @moduledoc """
  Ravenx strategy behaviour for mocking with ease
  """

  @type validations_errors :: list(tuple())

  @callback call(payload :: map(), opts :: map()) :: :ok | {:error, reason :: term}
end
