defmodule Todo.App do
  use Application

  def start(_, _) do
    Todo.System.start_link()
  end
end
