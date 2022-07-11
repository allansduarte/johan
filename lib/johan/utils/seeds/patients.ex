defmodule Johan.Seeders.PatientsSeeder do
  @moduledoc """
  Patient seeds.
  """

  alias Johan.Alerts.Schemas.Patients

  @doc "Returns a list of all #{Patients} going to be seeded"
  @spec get_patients(health_center_id :: String.t()) :: list(map())
  def get_patients(health_center_id) do
    [
      %{first_name: "Allan", last_name: "Duarte", addresses: [%{street: "Coronel Francisco Gomes street", number: 1227}], health_centers_id: health_center_id},
      %{first_name: "Neymar", last_name: "Junior", addresses: [%{street: "Broadway street", number: 40}], health_centers_id: health_center_id},
      %{first_name: "Ronaldinho", last_name: "Gaúcho", addresses: [%{street: "Bourbon street", number: 127}], health_centers_id: health_center_id}
    ]
  end
end
