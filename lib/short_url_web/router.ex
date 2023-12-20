defmodule ShortUrlWeb.Router do
  alias ShortUrlWeb.Auth.Guardian
  use ShortUrlWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortUrlWeb do
    get("/:code", UrlController, :redirect_page)
  end

  scope "/api", ShortUrlWeb do
    pipe_through :api
    post("/users", UserController, :create)
    resources "/users", UserController, only: [:show, :update, :delete]
    resources "/urls", UrlController, only: [:create, :show, :delete]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:short_url, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ShortUrlWeb.Telemetry
    end
  end
end
