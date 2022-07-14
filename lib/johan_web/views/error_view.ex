defmodule JohanWeb.ErrorView do
  use JohanWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  @doc "Render the response from custom errors"
  @spec render(String.t(), map()) :: map()
  def render("error.json", %{type: type, reason: reason, error: error}) do
    %{type: type, reason: reason, error: error}
  end

  def render("error.json", %{type: type, reason: reason}) do
    %{type: type, reason: reason}
  end

  def render("error.json", %{type: type}) do
    %{type: type}
  end
end
