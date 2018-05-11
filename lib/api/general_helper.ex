defmodule Api.GeneralHelper do

  def get_current_user(conn), do: Guardian.Plug.current_resource(conn)

  def tasks_for_user(user) do
    user
    |> Ecto.assoc(:tasks)
  end
end