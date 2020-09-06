defmodule Z19rpwWeb.Router do
  use Z19rpwWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Z19rpwWeb.Plug.AuthAccessPipeline
  end

  scope "/api", Z19rpwWeb do
    pipe_through :api

    scope "/auth" do
      post "/identity/callback", AuthenticationController, :identity_callback
    end

    pipe_through :authenticated

    resources "/users", UserController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: Z19rpwWeb.Telemetry
    end
  end
end
