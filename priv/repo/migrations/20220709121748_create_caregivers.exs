defmodule Johan.Repo.Migrations.CreateCaregivers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm", "DROP EXTENSION pg_trgm"

    create_if_not_exists table(:caregivers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :phone_number, :string
      add :health_center_id, references(:health_center, validate: false, type: :uuid)

      timestamps()
    end

    create_if_not_exists unique_index(:caregivers, [:phone_number, :health_center_id])
  end
end
