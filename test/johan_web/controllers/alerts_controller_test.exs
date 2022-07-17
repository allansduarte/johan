defmodule JohanWeb.AlertsControllerTest do
  use JohanWeb.ConnCase, async: true

  alias Johan.NotificationDispatcher.Ports.SendNotificationMock

  describe "POST /api/alerts" do
    test "with valid payload", ctx do
      device = insert(:devices)

      payload = %{
        status: "received",
        api_version: "v1",
        sim_sid: device.sim_sid,
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847",
        direction: "from_sim"
      }

      expect(SendNotificationMock, :send_notification, fn _message_input -> :ok end)

      response = post(ctx.conn, "/api/alerts", payload)

      assert 201 == response.status
      assert "OK" == response.resp_body
    end

    test "with invalid payload", ctx do
      payload = %{
        status: "received",
        api_version: "v1",
        sim_sid: "HSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        content: "ALERT DT=2015-07-30T20:00:00Z T=UNKNOWN VAL=200 LAT=52.1544408 LON=4.2934847",
        direction: "from_sim"
      }

      assert %{
               "errors" => [%{"type" => ["is invalid"]}],
               "reason" => "invalid_params",
               "type" => "jrn:error:invalid_params"
             } =
               ctx.conn
               |> post("/api/alerts", payload)
               |> json_response(422)
    end

    test "with device not found", ctx do
      payload = %{
        status: "received",
        api_version: "v1",
        sim_sid: "HSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        content: "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847",
        direction: "from_sim"
      }

      assert %{"type" => "jrn:error:not_found"} =
               ctx.conn
               |> post("/api/alerts", payload)
               |> json_response(404)
    end
  end

  describe "GET /api/alerts" do
    setup do
      alerts = insert_list(10, :alerts)

      {:ok, alerts: alerts}
    end

    test "succeeds if params are empty", ctx do
      dt_at = NaiveDateTime.to_iso8601(NaiveDateTime.utc_now())

      assert %{
               "data" => [
                 %{
                   "created" => _,
                   "lat" => _,
                   "lon" => _,
                   "metadata" => _,
                   "patients_id" => _
                 }
                 | _alerts
               ],
               "page_number" => 1,
               "page_size" => 5,
               "total_entries" => 10,
               "total_pages" => 2
             } =
               ctx.conn
               |> get(
                 "/api/alerts",
                 %{
                   "filter" => %{"type" => "BPM", "created_at_start" => dt_at},
                   "page_size" => "5"
                 }
               )
               |> json_response(200)
    end

    test "renders an empty list if nothing was found", ctx do
      assert %{
               "data" => [],
               "page_number" => 1,
               "page_size" => 10,
               "total_entries" => 0,
               "total_pages" => 1
             } =
               ctx.conn
               |> get("/api/alerts", %{"filter" => %{"type" => "FALL"}})
               |> json_response(200)
    end

    test "fails if params are invalid", ctx do
      assert %{
               "errors" => [%{"filter" => %{"type" => ["is invalid"]}}],
               "reason" => "invalid_params",
               "type" => "jrn:error:invalid_params"
             } ==
               ctx.conn
               |> get("/api/alerts", %{
                 "filter" => ~s/{"type": "invalid_type"}/
               })
               |> json_response(422)
    end
  end
end
