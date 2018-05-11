defmodule Api.GuardianAuthService do
  import Plug.Conn

  def create_token_for_user(conn, user) do
    new_conn      = Guardian.Plug.api_sign_in(conn, user)
    jwt           = Guardian.Plug.current_token(new_conn)
    {:ok, claims} = Guardian.Plug.claims(new_conn)
    exp           = Map.get(claims, "exp")

    new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")

    {new_conn, jwt, exp}
  end

  def revoke_token(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
  end
end