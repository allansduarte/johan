defmodule Johan.Notifications.Strategy.PatientAlertTest do
  use Johan.DataCase, async: true

  alias Johan.Notifications.SMSMock
  alias Johan.Notifications.Strategy.PatientAlert

  describe "call/2" do
    test "can send SMS codes" do
      params = %{
        value: "89415341023191537574",
        type: "BPM",
        date: "07/17/2022 23:45:11",
        first_name: "John",
        last_name: "Travolta"
      }

      expect(SMSMock, :dispatch_sms, fn "89415341023191537574", message ->
        assert message =~ "JOHAN: BPM type incident on 07/17/2022 23:45:11 for patient John Travolta."
        {:ok, %{data: %{}, status: 200}}
      end)

      assert {:ok, %{data: %{}, status: 200}} ==
               PatientAlert.call(params)
    end
  end
end
