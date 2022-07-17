defmodule Johan.Notifications.Strategy.PatientAlert do
  @moduledoc """
  Strategy for sending patient alerts to the caregiver.
  """

  alias Johan.Notifications.SMS

  require Logger

  @behaviour Johan.Notifications.StrategyBehaviour

  @sms_message "JOHAN: <%= type %> type incident on <%= date %> for patient <%= first_name %> <%= last_name %>."

  @doc """
  Send alerts to the given channel.

  It's send alerts for channels:
  - SMS
  """
  @impl true
  def call(params, opts \\ %{})

  def call(params, opts) when is_map(params) and is_map(opts) do
    Logger.debug("Running notification [#{__MODULE__}] strategy")

    send_sms(params)
  end

  def call(_params, _opts), do: {:error, :invalid_params}

  defp send_sms(params) do
    message =
      @sms_message
      |> String.replace("<%= type %>", params.type)
      |> String.replace("<%= date %>", params.date)
      |> String.replace("<%= first_name %>", params.first_name)
      |> String.replace("<%= last_name %>", params.last_name)

    params.value
    |> SMS.dispatch_sms(message)
    |> case do
      {:ok, response} ->
        Logger.info("""
        SMS notification [#{__MODULE__}] sent with success.
        Response: #{inspect(response)}
        """)

        {:ok, response}

      {:error, error} ->
        Logger.error("""
        SMS notification [#{__MODULE__}] failed.
        Response: #{inspect(error)}
        """)

        {:error, error}
    end
  end
end
