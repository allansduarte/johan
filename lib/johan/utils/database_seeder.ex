defmodule Johan.DatabaseSeeder do
  @moduledoc """
  Database seeder.

  It inserts a default data to be used on application.
  """

  require Logger

  alias Johan.Alerts.Schemas.{
    HealthCenters,
    Caregivers,
    Patients,
    Devices
  }

  alias Johan.Repo

  alias Johan.Seeders.{
    HealthCentersSeeder,
    CaregiversSeeder,
    PatientsSeeder,
    DevicesSeeder
  }

  @doc "Populates the tables health_centers"
  @spec populate_health_centers!() :: [HealthCenters.t()]
  def populate_health_centers! do
    IO.puts("Running Johan [Database Seeder] populate_health_centers!")

    populate_schema_with_data(HealthCentersSeeder.get_health_centers(), HealthCenters)
  end

  @doc "Populates the tables patients"
  @spec populate_patients!(health_center_id :: String.t()) :: [Patients.t()]
  def populate_patients!(health_center_id) do
    IO.puts("Running Johan [Database Seeder] populate_patients!")

    populate_schema_with_data(PatientsSeeder.get_patients(health_center_id), Patients)
  end

  @doc "Populates the tables caregives and devices"
  @spec populate_associations!(health_center_id :: String.t(), patient_id :: String.t()) :: :ok
  def populate_associations!(health_center_id, patient_id) do
    IO.puts("Running Johan [Database Seeder] populate_associations!")

    Repo.transaction(fn ->
      populate_schema(CaregiversSeeder.get_caregivers(health_center_id), Caregivers)
      populate_schema(DevicesSeeder.get_devices(health_center_id, patient_id), Devices)
    end)
  end

  defp populate_schema(params_list, schema) when is_list(params_list) and is_atom(schema) do
    Enum.each(params_list, fn params ->
      params
      |> schema.changeset()
      |> Repo.insert(on_conflict: :nothing)
      |> case do
        {:ok, data} -> {:ok, data}
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp populate_schema_with_data(params_list, schema) when is_list(params_list) and is_atom(schema) do
    Enum.map(params_list, fn params ->
      params
      |> schema.changeset()
      |> Repo.insert(on_conflict: :nothing)
      |> case do
        {:ok, data} -> {:ok, data}
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end
end
