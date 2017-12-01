defmodule EctoTest.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, size: 255
    end
  end
end
