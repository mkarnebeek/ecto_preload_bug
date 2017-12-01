defmodule EctoTest.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :name, :string
    belongs_to :role, EctoTest.Role, type: Ecto.UUID
  end

  @required_fields ~w(name role_id)a
  @optional_fields ~w()a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
