defmodule Todo.Database do
  def child_spec(_) do
    IO.puts("Starting db")
    db_setting = Application.fetch_env!(:todo, :database)
    db_folder = Keyword.fetch!(db_setting, :folder)

    File.mkdir_p!(db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: Keyword.fetch!(db_setting, :pool_size)
      ],
      [db_folder]
    )
  end

  def store(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
      end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end
end
