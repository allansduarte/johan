defmodule Johan.Notifications do
  @moduledoc """
  Public interface for notifications domain logic.
  """

  require Logger

  alias Johan.ChangesetValidation
  alias Johan.Notifications.Inputs.CreateNotification
  alias Johan.Notifications.Strategy

  @doc "Sends a notification to the profile"
  @spec send_notification(map()) :: {:ok, list()} | {:error, any()}
  def send_notification(params) do
    case ChangesetValidation.cast_and_apply(CreateNotification, params) do
      {:ok, input} ->
        Logger.debug("Sending notification: #{inspect(input.event)}")

        input.event
        |> get_event_type()
        |> Ravenx.dispatch(input.data)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, {:validation, changeset}}

      err ->
        err
    end
  end

  def get_event_type(type) do
    if type in Strategy.all_strategies() do
      String.to_atom(type)
    else
      raise "Notification event type unknown. Event type: #{inspect(type)}"
    end
  end
end
