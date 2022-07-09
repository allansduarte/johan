defmodule Johan.Repo.Migrations.CreatePatients do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm", "DROP EXTENSION pg_trgm"

    create_if_not_exists table(:patients, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :addresses, {:array, :map}, null: false
      add :metadata, :map
      add :health_center_id, references(:health_center, validate: false, type: :uuid)
    end

    create_if_not_exists unique_index(:patients, [:first_name, :last_name, :health_center_id])
  end
end
