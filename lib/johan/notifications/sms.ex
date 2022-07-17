defmodule Johan.Notifications.SMS do
  @moduledoc """
  SMS notification channel.

  The short message service protocol is used to send messages to phones directly.
  """
  use Knigge, otp_app: :johan

  @doc """
  Generic dispatcher
  """
  @callback dispatch_sms(target :: String.t(), body :: String.t()) ::
              {:ok, %{data: map(), status: pos_integer()}}
              | {:error, %{data: map(), status: pos_integer()}}
end
