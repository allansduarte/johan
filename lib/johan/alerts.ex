defmodule Johan.Alerts do
  @moduledoc """
  Alerts context
  """

  alias Johan.Alerts.Commands.CreateAlert
  alias Johan.Alerts.Inputs.ListAlert, as: ListAlertInput
  alias Johan.Repo

  @doc "See `Johan.Alerts.Commands.CreateAlert.execute/1`"
  defdelegate create(input), to: CreateAlert, as: :execute

  @doc "Returns a list of `Alerts`"
  @spec list(input :: ListAlertInput.t()) :: {:ok, Scrivener.Page.t()}
  def list(%ListAlertInput{page_size: page_size, page: page} = input) do
    input
    |> ListAlertInput.to_query()
    |> Repo.paginate(page_size: page_size, page: page)
  end
end
