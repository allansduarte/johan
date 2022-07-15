defmodule JohanWeb.AlertsView do
  use JohanWeb, :view

  def render("alert.json", %{alerts: alert}) do
    %{
      type: alert.type,
      created: alert.created,
      value: alert.value,
      lat: alert.lat,
      lon: alert.lon,
      metadata: alert.metadata,
      patients_id: alert.patients_id
    }
  end

  def render("show.json", %{alerts: alerts}) do
    %{
      data: render_many(alerts.entries, __MODULE__, "alert.json"),
      page_number: alerts.page_number,
      page_size: alerts.page_size,
      total_pages: alerts.total_pages,
      total_entries: alerts.total_entries
    }
  end
end
