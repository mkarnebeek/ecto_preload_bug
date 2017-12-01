defmodule EctoTestTest do
  use ExUnit.Case
  doctest EctoTest

  setup do
    {:ok, role1} = insert_role("Role 1")
    {:ok, _} = insert_permission("Permission 1", role1)

    {:ok, role2} = insert_role("Role 2")
    {:ok, _} = insert_permission("Permission 2", role2)

    {:ok, user} = insert_user("User")

    {:ok, [user: user, role1: role1, role2: role2]}
  end

  def insert_user(name) do
    %EctoTest.User{}
    |> EctoTest.User.changeset(%{name: name})
    |> EctoTest.Repo.insert()
  end

  def insert_role(name) do
    %EctoTest.Role{}
    |> EctoTest.Role.changeset(%{name: name})
    |> EctoTest.Repo.insert()
  end

  def insert_permission(name, role) do
    %EctoTest.Permission{}
    |> EctoTest.Permission.changeset(%{name: name, role_id: role.id})
    |> EctoTest.Repo.insert()
  end

  test "preloading on a single duty", o do
    duty1 =
      o.role1
      |> new_dynamic_duty(o.user, 1)
      |> EctoTest.Repo.preload(role: [:permissions])

    assert duty1.name == "Dynamic duty 1"
    assert duty1.role.name == "Role 1"
    [permission1] = duty1.role.permissions
    assert permission1.name == "Permission 1"

    duty2 =
      o.role2
      |> new_dynamic_duty(o.user, 2)
      |> EctoTest.Repo.preload(role: [:permissions])

    assert duty2.name == "Dynamic duty 2"
    assert duty2.role.name == "Role 2"
    [permission2] = duty2.role.permissions
    assert permission2.name == "Permission 2"
  end

  test "preloading on a list of duties", o do
    user_with_dynamic_duties =
      EctoTest.User
      |> EctoTest.Repo.get(o.user.id)
      |> EctoTest.Repo.preload([:duties])
      |> add_dynamic_duties(o.role1, o.role2)

    [duty1, duty2] = user_with_dynamic_duties.duties
    assert duty1.name == "Dynamic duty 1"
    assert duty1.role.name == "Role 1"
    assert duty2.name == "Dynamic duty 2"
    assert duty2.role.name == "Role 2"

    user_with_dynamic_duties_and_preloaded_permissions =
      user_with_dynamic_duties
      |> EctoTest.Repo.preload(duties: [role: [:permissions]])

    [duty1, duty2] = user_with_dynamic_duties_and_preloaded_permissions.duties

    assert duty1.name == "Dynamic duty 1"
    assert duty1.role.name == "Role 1"
    [permission1] = duty1.role.permissions
    assert permission1.name == "Permission 1"

    assert duty2.name == "Dynamic duty 2"
    assert duty2.role.name == "Role 2"
    [permission2] = duty2.role.permissions
    assert permission2.name == "Permission 2"
  end

  def add_dynamic_duties(user, role1, role2) do
    dynamic_duty1 = new_dynamic_duty(role1, user, 1)
    dynamic_duty2 = new_dynamic_duty(role2, user, 2)

    %{user | duties: user.duties ++ [dynamic_duty1, dynamic_duty2]}
  end

  def new_dynamic_duty(role, user, nr) do
    %EctoTest.Duty{
      user: user,
      name: "Dynamic duty #{nr}",
      role: role,
      #role_id: role.id
    }
  end
end
