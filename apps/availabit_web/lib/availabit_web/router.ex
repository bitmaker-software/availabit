defmodule AvailabitWeb.Router do
  use AvailabitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AvailabitWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/events", EventController
  end

  # Other scopes may use custom stacks.
  # scope "/api", AvailabitWeb do
  #   pipe_through :api
  # end
end
