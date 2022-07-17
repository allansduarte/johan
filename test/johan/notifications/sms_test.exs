defmodule Johan.Notifications.SMSTest do
  use Johan.DataCase, async: true

  alias Johan.Notifications.SMS
  alias Johan.Notifications.SMSMock

  describe "send" do
    test "can send" do
      expect(SMSMock, :dispatch_sms, fn "11912345678", "Teste" ->
        {:ok, %{data: %{}, status: 200}}
      end)

      SMS.dispatch_sms("11912345678", "Teste")
    end
  end
end
