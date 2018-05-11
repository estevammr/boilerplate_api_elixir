defmodule Api.GuardianAuthErrorHandler do

  @callback unauthenticated(Plug.t, Map.t) :: Plug.t
  @callback unauthorized(Plug.t, Map.t) :: Plug.t

  import Plug.Conn

  def unauthenticated(conn, _params) do
    respond(conn, :json, 401, "Unauthenticated")
  end

  def unauthorized(conn, _params) do
    respond(conn, :json, 403, "Unauthorized")
  end

  def already_authenticated(conn, _params) do
    conn |> halt
  end

  defp respond(conn, :json, status, msg) do
    try do
      conn
      |> configure_session(drop: true)
      |> put_resp_content_type("application/json")
      |> send_resp(status, Poison.encode!(%{errors: [%{details: msg}]}))
    rescue ArgumentError ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, Poison.encode!(%{errors: [%{details: msg}]}))
    end
  end

end