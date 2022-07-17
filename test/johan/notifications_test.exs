defmodule Johan.NotificationsTest do
  use Johan.DataCase, async: true

  alias Johan.Notifications
  alias Johan.Notifications.SMSMock

  describe "send_notification/2" do
    test "succeeds on patient_alert send when params are valid" do
      params = %{
        "event" => "patient_alert",
        "data" => %{
          value: "89415341023191537574",
          type: "BPM",
          date: "07/17/2022 23:45:11",
          first_name: "John",
          last_name: "Travolta"
        }
      }

      expect(SMSMock, :dispatch_sms, fn "89415341023191537574", message ->
        assert message =~ "JOHAN: BPM type incident on 07/17/2022 23:45:11 for patient John Travolta."
        {:ok, %{data: %{}, status: 200}}
      end)

      assert {:ok, %{data: %{}, status: 200}} == Notifications.send_notification(params)
    end

    test "fails whenn event is not valid" do
      params = %{
        "event" => "unknown",
        "data" => %{
          value: "89415341023191537574",
          type: "BPM",
          date: "07/17/2022 23:45:11",
          first_name: "John",
          last_name: "Travolta"
        }
      }

      assert {:error, {:validation, %{errors: errors}}} = Notifications.send_notification(params)
      assert [event: {"is invalid", _}] = errors
    end
  end
end
