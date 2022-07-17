defmodule Johan.Notifications.Commands.SendNotification do
  @moduledoc """
  Calls the correct strategy by the given parameters and send the notification.
  """

  require Logger

  alias Johan.Notifications

  @doc """
  Send a notification through a strategy.

  It must adhere to Johan.Notifications.Inputs.CreateNotification
  """
  @spec send_notification(params :: map()) :: :ok | {:error, :notification_failed}
  def send_notification(params) do
    Logger.info("#{__MODULE__} sending notification")

    params
    |> Notifications.send_notification()
    |> case do
      :ok ->
        :ok

      {:ok, _} ->
        :ok

      error ->
        Logger.error("#{__MODULE__} failed on sending notitication", error: inspect(error))
        {:error, :notification_failed}
    end
  end
end
