defmodule JohanWeb.AlertsControllerTest do
  use JohanWeb.ConnCase, async: true

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
end
