defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    bob_pid = Todo.Cache.server_process("bob")

    assert bob_pid != Todo.Cache.server_process("alice")
    assert bob_pid == Todo.Cache.server_process("bob")
  end

  test "todo operations" do
    alice = Todo.Cache.server_process("alice")
    Todo.Server.add_entry(alice, %{date: ~D[2020-02-02], title: "Dinner"})
    entries = Todo.Server.entries(alice, ~D[2020-02-02])

    assert [%{date: ~D[2020-02-02], title: "Dinner"}] = entries
  end

  test "persistent" do
    john = Todo.Cache.server_process("john")
    Todo.Server.add_entry(john, %{date: ~D[2020-02-02], title: "Dinner"})
    assert 1 == length(Todo.Server.entries(john, ~D[2020-02-02]))

    Process.exit(john, :kill)

    entries =
      "john"
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(~D[2020-02-02])

    assert [%{date: ~D[2020-02-02], title: "Dinner"}] = entries
  end
end
