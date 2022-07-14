defmodule Johan.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm", "DROP EXTENSION pg_trgm"

    create_if_not_exists table(:alerts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :created, :naive_datetime_usec
      add :type, :string
      add :value, :string
      add :lat, :string
      add :lon, :string
      add :metadata, :map
      add :patients_id, references(:patients, type: :uuid)
    end
  end
end
