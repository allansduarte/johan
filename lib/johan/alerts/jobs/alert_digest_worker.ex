defmodule Johan.Alerts.Jobs.AlertDigestWorker do
  use Oban.Worker, queue: :default

  require Logger

  alias Johan.NotificationDispatcher

  @impl Oban.Worker
  def perform(%Oban.Job{
        args:
          %{
            "sim_sid" => sim_sid,
            "first_name" => first_name,
            "last_name" => last_name,
            "type" => type,
            "created" => created
          } = args
      }) do
    Logger.metadata(args: args)

    NotificationDispatcher.send_notification(%{
      event: "patient_alert",
      data: %{
        value: sim_sid,
        type: type,
        date: created,
        first_name: first_name,
        last_name: last_name
      }
    })
  end
end
