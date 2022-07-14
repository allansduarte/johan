defmodule JohanWeb.FallbackController do
  use JohanWeb, :controller

  alias JohanWeb.{ChangesetView, ErrorView}

  @urn_params "jrn:error:invalid_params"
  @urn_not_found "jrn:error:not_found"

  @validation_errors [:invalid_params, :invalid_format]
  @not_found_errors [
    :not_found,
    :device_not_found
  ]

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ChangesetView)
    |> render("changeset_error.json", %{
      type: @urn_params,
      reason: :invalid_params,
      changeset: changeset
    })
  end

  def call(conn, {:error, reason}) when reason in @not_found_errors do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("error.json", %{type: @urn_not_found})
  end

  def call(conn, {:error, reason}) when reason in @validation_errors do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", %{
      type: @urn_params,
      reason: :validation_error,
      error: reason
    })
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(JohanWeb.ErrorView)
    |> render("error.json", %{type: @urn_params, reason: reason})
  end
end
