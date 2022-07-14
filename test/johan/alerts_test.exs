defmodule Johan.AlertsTest do
  use Johan.DataCase, async: true

  alias Johan.Alerts.Inputs.Alert
  alias Johan.Alerts

  describe "create/1" do
    test "delegates to command execution" do
      device = insert(:devices)

      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: device.sim_sid,
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      assert {:ok, alert} = Alerts.create(input)
      assert alert.patients_id == device.patients_id
    end
  end
end
