defmodule Api.Web.TaskController do
  use Api.Web, :controller

  alias Api.Core
  alias Api.GeneralHelper, as: GH
  alias Api.Core.Task

  action_fallback Api.Web.FallbackController

  def index(conn, _params) do
    user = GH.get_current_user(conn)
    tasks = Core.list_tasks(user)
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    user = GH.get_current_user(conn)
    with {:ok, %Task{} = task} <- Core.create_task(task_params, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    user = GH.get_current_user(conn)
    with %Task{} = task <- Core.get_task(id, user) do
      render(conn, "show.json", task: task)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = GH.get_current_user(conn)
    with %Task{} = task <- Core.get_task(id, user),
        {:ok, %Task{} = task} <- Core.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = GH.get_current_user(conn)
    with %Task{} = task <- Core.get_task(id, user),
         {:ok, %Task{}} <- Core.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end