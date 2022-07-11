defmodule Johan.Seeders.HealthCentersSeeder do
  @moduledoc """
  HealthCenter seeds.
  """

  alias Johan.Alerts.Schemas.HealthCenter

  @doc "Returns a list of all #{HealthCenter} going to be seeded"
  @spec get_health_centers() :: list(map())
  def get_health_centers do
    [
      %{name: "Johan Hospital"},
      %{name: "San José"},
      %{name: "Kiou Hospital"}
    ]
  end
end
