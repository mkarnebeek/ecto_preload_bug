defmodule EctoTest.Duty do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "duties" do
    field :name, :string
    belongs_to :role, EctoTest.Role, type: Ecto.UUID
    belongs_to :user, EctoTest.User, type: Ecto.UUID
  end

  @required_fields ~w(name role_id user_id)a
  @optional_fields ~w()a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
