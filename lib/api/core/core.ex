defmodule Api.Core do
  import Ecto.Query, warn: false

  alias Api.Repo
  alias Api.GeneralHelper, as: GH
  alias Api.Core.Task

  def list_tasks(user) do
    user
    |> GH.tasks_for_user
    |> Repo.all
  end

  def get_task(id, user) do
    task =
      user
      |> GH.tasks_for_user
      |> Repo.get(id)

    case task do
      nil ->
        {:error, :not_found}
      _user ->
        task
    end
  end

  def create_task(attrs, user) do
    user
    |> Ecto.build_assoc(:tasks)
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end
end