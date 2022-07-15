defmodule JohanWeb.AlertsController do
  use JohanWeb, :controller

  alias Johan.Alerts
  alias Johan.ChangesetValidation

  alias Johan.Alerts.Inputs.{
    Alert,
    ListAlert
  }

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

  @doc "Lists an alert"
  @spec show(Conn.t(), params :: map()) :: Conn.t()
  def show(conn, params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(ListAlert, params),
         %Scrivener.Page{} = alerts <- Alerts.list(input) do
      conn
      |> put_status(:ok)
      |> render("show.json", alerts: alerts)
    end
  end
end
