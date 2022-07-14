defmodule JohanWeb.AlertsController do
  use JohanWeb, :controller

  alias Johan.Alerts
  alias Johan.ChangesetValidation
  alias Johan.Alerts.Inputs.Alert
  alias Johan.Alerts

  action_fallback JohanWeb.FallbackController

  @doc "Creates an alert"
  @spec create(Conn.t(), params :: map()) :: Conn.t()
  def create(conn, params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(Alert, params),
         {:ok, _alert} <- Alerts.create(input) do
      send_resp(conn, 201, "OK")
    end
  end
end
