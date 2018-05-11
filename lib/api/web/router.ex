defmodule Api.Web.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_api do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Api.GuardianAuthErrorHandler
  end

  scope "/", Api.Web do
    pipe_through :api
    post "/users",                  UserController,   :create
    post "/users/login",            UserController,   :login
  end

  scope "/", Api.Web do
    pipe_through [:api, :authenticated_api]
    resources "/users",             UserController,      only: [:update]
    get       "/users/show_current",UserController,            :show_current
    resources "/tasks",             TaskController,  only: [:create, :delete, :show, :update, :index]
  end
end