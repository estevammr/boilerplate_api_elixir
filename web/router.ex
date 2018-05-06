defmodule Api.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1", Api do
    pipe_through :api

    post "/sign_up", RegistrationController, :sign_up
    post "/sign_in", SessionController, :sign_in # Add this line

    pipe_through :authenticated
    resources "/users", UserController, except: [:new, :edit]
  end
  
end
