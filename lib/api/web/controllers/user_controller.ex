defmodule Api.Web.UserController do
  use Api.Web, :controller

  alias Api.Accounts
  alias Api.GeneralHelper
  alias Api.{Accounts.User, Repo, GuardianAuthService}

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  action_fallback Api.Web.FallbackController

  def login(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        {new_conn, jwt, exp} = GuardianAuthService.create_token_for_user(conn, user)
        new_conn
        |> put_status(:ok)
        |> render("user_with_jwt.json", user: user, jwt: jwt, exp: exp)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw()
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end
  def login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("bad_request.json")
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      {new_conn, jwt, exp} = GuardianAuthService.create_token_for_user(conn, user)
      new_conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show_current))
      |> render("user_with_jwt.json", user: user, jwt: jwt, exp: exp)
    end
  end

  def show_current(conn, _) do
    user = GeneralHelper.get_current_user(conn)
    render(conn, "user.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "user.json", user: user)
    end
  end
end