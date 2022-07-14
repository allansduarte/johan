defmodule Johan.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Johan.Repo

  alias Johan.Alerts.Schemas.{
    Devices,
    Patients,
    HealthCenters
  }

  def devices_factory do
    %Devices{
      sim_sid: "89415341023191537574",
      patients: build(:patients),
      health_centers: build(:health_centers)
    }
  end

  def health_centers_factory, do: %HealthCenters{name: Faker.Company.En.bs()}

  def patients_factory do
    %Patients{
      first_name: "Allan",
      last_name: "Duarte",
      metadata: %{responsible: "John"},
      addresses: [%{street: "Inambú street", number: 4000}],
      health_centers: build(:health_centers)
    }
  end
end
