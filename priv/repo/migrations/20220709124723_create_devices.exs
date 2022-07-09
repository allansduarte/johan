defmodule Johan.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm", "DROP EXTENSION pg_trgm"

    create_if_not_exists table(:devices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :sim_sid, :string, null: false
      add :patient_id, references(:patients, validate: false, type: :uuid)
      add :health_center_id, references(:health_center, validate: false, type: :uuid)
    end

    create_if_not_exists unique_index(:devices, [:sim_sid])
  end
end
