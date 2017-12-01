defmodule EctoTest.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :name, :string
    has_many :duties, EctoTest.Duty
  end

  @required_fields ~w(name)a
  @optional_fields ~w()a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
