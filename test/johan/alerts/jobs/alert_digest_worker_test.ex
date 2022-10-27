defmodule Johan.Alerts.Jobs.AlertDigestWorkerTest do
  use Johan.DataCase, async: true

  alias Johan.Alerts.Jobs.AlertDigestWorker, as: AlertJob
  alias Johan.NotificationDispatcher.Ports.SendNotificationMock

  describe "perform/2" do
    test "sends notification" do
      device = insert(:devices)

      expect(SendNotificationMock, :send_notification, fn message_input ->
        assert message_input.event == "patient_alert"
        assert message_input.data.value == device.sim_sid
        assert message_input.data.first_name == device.patients.first_name
        assert message_input.data.last_name == device.patients.last_name
        assert message_input.data.type == "BPM"
        assert message_input.data.date == "7/30/2015 20:0:0"

        :ok
      end)

      assert :ok =
               perform_job(AlertJob, %{
                 "sim_sid" => device.sim_sid,
                 "first_name" => device.patients.first_name,
                 "last_name" => device.patients.last_name,
                 "type" => "BPM",
                 "created" => "7/30/2015 20:0:0"
               })
    end
  end
end
