ExUnit.start()

Application.ensure_all_started(:mox)

Mox.defmock(Tesla.MockAdapter, for: Tesla.Adapter)
