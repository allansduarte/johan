defmodule Johan.NotificationDispatcher.Ports.SendNotification do
  @moduledoc """
  Send a notification with the given parameters

  To know more about how should it works checks:
    - https://github.com/sascha-wolf/knigge
  """

  use Knigge, otp_app: :johan

  @type event :: %{
          event: String.t(),
          data: %{
            type: String.t(),
            profile_id: String.t(),
            event_happened_at: NaiveDateTime.t()
          }
        }

  @callback send_notification(params :: event()) :: :ok | {:error, :notification_failed}
end
