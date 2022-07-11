defmodule Johan.Seeders.CaregiversSeeder do
  @moduledoc """
  Caregiver seeds.
  """

  alias Johan.Alerts.Schemas.Caregivers

  @doc "Returns a list of all #{Caregivers} going to be seeded"
  @spec get_caregivers(health_center_id :: String.t()) :: list(map())
  def get_caregivers(health_center_id) do
    [
      %{phone_number: "+5547988009911", health_centers_id: health_center_id},
      %{phone_number: "+5547988009911", health_centers_id: health_center_id},
      %{phone_number: "+5547988009911", health_centers_id: health_center_id}
    ]
  end
end
