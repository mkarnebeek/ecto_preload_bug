defmodule EctoTest.Repo.Migrations.CreateDuties do
  use Ecto.Migration

  def change do
    create table(:duties, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :role_id, references(:roles, type: :uuid, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :name, :string, size: 255
    end
  end
end
