defmodule Api.Web.UserView do
  use Api.Web, :view
  alias Api.Web.UserView

  def render("user_with_jwt.json", %{user: user, jwt: jwt, exp: exp}) do
    %{data: %{id: user.id,
              full_name: user.full_name,
              email: user.email,
              jwt: jwt,
              jwt_expiration: exp}
    }
  end

  def render("user.json", %{user: user}) do
    %{data: %{id: user.id,
              full_name: user.full_name,
              email: user.email}
    }
  end

  def render("error.json", _assigns) do
    %{errors: "Invalid credentials"}
  end

  def render("bad_request.json", _params) do
    %{errors: [%{details: "Bad request"}]}
  end
end