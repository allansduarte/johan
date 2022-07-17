defmodule Johan.Notifications.SMS.Dispatcher do
  @moduledoc """
  Dispatch an SMS through Twilio
  """

  alias ExTwilio.Message
  alias Johan.ValueObjectSchema

  @default_johan_twilio_number "9999"

  @doc """
  Call Twilio create message API. It uses authentication through configuration.

  Possible errors:

      {:error,    %{
        "code" => 20404,
        "message" => "The requested resource /2010-04-01/Messages.json was not found",
        "more_info" => "https://www.twilio.com/docs/errors/20404",
        "status" => 404
      }, 404}

  Example success response:

      {:ok,
       %ExTwilio.Message{
         account_sid: string(),
         api_version: "2010-04-01",
         body: "Another test!! :)",
         date_created: "Wed, 04 Nov 2020 15:22:11 +0000",
         date_sent: nil,
         date_updated: "Wed, 04 Nov 2020 15:22:11 +0000",
         direction: "outbound-api",
         error_code: nil,
         error_message: nil,
         from: string(),
         messaging_service_sid: nil,
         num_media: "0",
         num_segments: "1",
         price: nil,
         price_unit: "USD",
         sid: string(),
         status: "queued",
         subresource_uri: nil,
         to: "+551191111111111",
         uri: "/2010-04-01/Accounts/string()/Messages/string().json"
       }}
  """
  @spec dispatch_sms(target :: String.t(), body :: String.t()) ::
          {:ok, %{data: map(), status: pos_integer()}}
          | {:error, %{data: map(), status: pos_integer()}}
  def dispatch_sms(target, body) do
    case Message.create(to: target, from: @default_johan_twilio_number, body: body) do
      {:ok, response} ->
        {:ok, %{data: response |> ValueObjectSchema.to_map(), status: 200}}

      {:error, error, status} ->
        {:error, %{data: error, status: status}}
    end
  end
end
