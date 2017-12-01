ExUnit.start()

:ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoTest.Repo)

Ecto.Adapters.SQL.Sandbox.mode(EctoTest.Repo, {:shared, self()})

