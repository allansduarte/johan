defmodule Johan.Repo.Migrations.CreateHealthCenter do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm", "DROP EXTENSION pg_trgm"

    create_if_not_exists table(:health_centers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    create_if_not_exists unique_index(:health_centers, [:name])
  end
end
