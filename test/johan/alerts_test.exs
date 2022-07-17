defmodule Johan.AlertsTest do
  use Johan.DataCase, async: true

  alias Johan.Alerts
  alias Johan.Alerts.Schemas.Alerts, as: AlertSchema
  alias Johan.NotificationDispatcher.Ports.SendNotificationMock

  alias Johan.Alerts.Inputs.{
    Alert,
    ListAlert
  }

  describe "create/1" do
    test "delegates to command execution" do
      device = insert(:devices)

      input = %Alert{
        status: "received",
        api_version: "v1",
        sim_sid: device.sim_sid,
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
      }

      expect(SendNotificationMock, :send_notification, fn _message_input -> :ok end)

      assert {:ok, alert} = Alerts.create(input)
      assert alert.patients_id == device.patients_id
    end
  end

  describe "list/1" do
    setup do
      alerts = insert_list(10, :alerts)

      {:ok, alerts: alerts}
    end

    test "returns all assessment requests if params are valid and input is admin" do
      input = %ListAlert{
        filter: %{type: :BPM, created_at_start: NaiveDateTime.utc_now()},
        page_size: 5
      }

      assert %Scrivener.Page{entries: [%AlertSchema{}, %AlertSchema{} | _]} = paginate =
               Alerts.list(input)

      assert paginate.page_number == 1
      assert paginate.page_size == 5
      assert paginate.total_entries == 10
      assert paginate.total_pages == 2
    end
  end
end
