defmodule Johan.Alerts.Commands.CreateAlertTest do
  use Johan.DataCase, async: true

  alias Johan.Alerts.Inputs.Alert
  alias Johan.Alerts.Commands.CreateAlert
  # alias Johan.NotificationDispatcher.Ports.SendNotificationMock
  alias Johan.Alerts.Jobs.AlertDigestWorker, as: AlertJob

  describe "CreateAlert/1" do
    test "with valid input" do
      device = insert(:devices)

      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: device.sim_sid,
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      alert_content = %{
        created: NaiveDateTime.from_iso8601!("2015-07-30T20:00:00Z"),
        type: "BPM",
        value: 200,
        lat: "52.1544408",
        lon: "4.2934847"
      }

      assert {:ok, alert} = CreateAlert.execute(input)
      assert alert.patients_id == device.patients_id

      assert_enqueued(
        worker: AlertJob,
        args: %{
          "sim_sid" => device.sim_sid,
          "first_name" => device.patients.first_name,
          "last_name" => device.patients.last_name,
          "type" => alert_content.type,
          "created" => "7/30/2015 20:0:0"
        }
      )
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
