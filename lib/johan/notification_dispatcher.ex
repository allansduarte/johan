defmodule Johan.NotificationDispatcher do
  @moduledoc """
  Dispatches notifications
  """

  alias Johan.NotificationDispatcher.Ports.SendNotification

  @doc "Sends a notification"
  @spec send_notification(data :: SendNotification.event()) ::
          :ok | {:error, :notification_failed}
  def send_notification(data) when is_map(data) do
    SendNotification.send_notification(data)
  end
end
