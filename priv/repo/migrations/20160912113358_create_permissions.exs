defmodule EctoTest.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :role_id, references(:roles, type: :uuid, on_delete: :delete_all), null: false
      add :name, :string, size: 255
    end
  end
end
