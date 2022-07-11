defmodule Johan.Seeders.DevicesSeeder do
  @moduledoc """
  Device seeds.
  """

  alias Johan.Alerts.Schemas.Devices

  @doc "Returns a list of all #{Devices} going to be seeded"
  @spec get_devices(health_center_id :: String.t(), patient_id :: String.t) :: list(map())
  def get_devices(health_center_id, patient_id) do
    [
      %{sim_sid: "89420051446171493957", health_centers_id: health_center_id, patients_id: patient_id},
      %{sim_sid: "89267021026891356551", health_centers_id: health_center_id, patients_id: patient_id},
      %{sim_sid: "89238011106061281657", health_centers_id: health_center_id, patients_id: patient_id}
    ]
  end
end
