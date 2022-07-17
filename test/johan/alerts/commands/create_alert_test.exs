defmodule Johan.Alerts.Commands.CreateAlertTest do
  use Johan.DataCase, async: true

  alias Johan.Alerts.Inputs.Alert
  alias Johan.Alerts.Commands.CreateAlert
  alias Johan.NotificationDispatcher.Ports.SendNotificationMock

  describe "CreateAlert/1" do
    test "with valid input" do
      device = insert(:devices)

      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: device.sim_sid,
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      expect(SendNotificationMock, :send_notification, fn message_input ->
        assert message_input.event == "patient_alert"
        assert message_input.data.value == device.sim_sid
        assert message_input.data.first_name == device.patients.first_name
        assert message_input.data.last_name == device.patients.last_name
        assert message_input.data.type == :BPM
        assert message_input.data.date == "7/30/2015 20:0:0"

        :ok
      end)

      assert {:ok, alert} = CreateAlert.execute(input)
      assert alert.patients_id == device.patients_id
    end

    test "with invalid format" do
      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: "aaa",
        content: "ALERT format=invalid"
      }

      assert {:error, :invalid_format} = CreateAlert.execute(input)
    end

    test "with invalid type" do
      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: "aaa",
        content: "ALERT DT=2015-07-30T20:00:00Z T=UNKNOWN VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      assert {:error, _changeset} = CreateAlert.execute(input)
    end

    test "when device not found" do
      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: "aaa",
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      assert {:error, :device_not_found} = CreateAlert.execute(input)
    end
  end
end
