defmodule SlackprojectWeb.Router do
  use SlackprojectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :api do
    plug :accepts, ["json"]
  end

    scope "/", SlackprojectWeb do
    pipe_through :browser # Use the default browser stack

    #post https://hooks.slack.com/services/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
    get "/", PageController, :index

    post "/call", SlackController, :call
  end
  # Other scopes may use custom stacks.
  # scope "/api", SlackprojectWeb do
  #   pipe_through :api
  # end
end
