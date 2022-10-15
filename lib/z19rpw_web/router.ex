defmodule Z19rpwWeb.Router do
  use Z19rpwWeb, :router
  use Pow.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowEmailConfirmation, PowResetPassword]

  import Phoenix.LiveDashboard.Router

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: Z19rpwWeb.APIAuthErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Z19rpwWeb.APIAuthPlug, otp_app: :z19rpw
  end

  pipeline :browser do
    plug :set_statistics
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/", Z19rpwWeb do
    get "/_status", StatusController, :status
  end

  scope "/" do
    pipe_through :browser
    pow_routes()
    pow_extension_routes()
  end

  scope "/", Z19rpwWeb do
    pipe_through [:browser, :protected]

    live "/posts/new", PostLive.Index, :new, layout: {Z19rpwWeb.LayoutView, "app.html"}

    live "/posts/:slug/edit", PostLive.Show, :edit, layout: {Z19rpwWeb.LayoutView, "app.html"}
  end

  scope "/", Z19rpwWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/thc", PageController, :thc
    get "/jordan", PageController, :jordan
    get "/russia", PageController, :russia
    get "/flow", PageController, :flow
    get "/bye", PageController, :err
    get "/coffee", PageController, :coffee
    get "/mentorship", PageController, :mentoring

    live "/blog", PostLive.Index, :index, layout: {Z19rpwWeb.LayoutView, "app.html"}

    live "/posts/author/:username", PostLive.Index, :user,
      layout: {Z19rpwWeb.LayoutView, "app.html"}

    live "/posts/:slug", PostLive.Show, :show, layout: {Z19rpwWeb.LayoutView, "app.html"}
  end

  scope "/api/", Z19rpwWeb, as: :api do
    pipe_through :api

    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api", Z19rpwWeb, as: :api do
    pipe_through [:api]
    resources "/posts", PostController, only: [:index, :show]
  end

  scope "/api", Z19rpwWeb, as: :api do
    pipe_through [:api, :api_protected]
    resources "/posts", PostController, except: [:index, :show]
  end

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]
    live_dashboard "/dashboard", metrics: Z19rpwWeb.Telemetry, ecto_repos: [Z19rpw.Repo]
  end

  defp set_statistics(conn, _opts) do
    conn
    |> assign(:hostname, String.downcase(System.get_env("HOSTNAME", "nohost")))
    |> assign(:start_time, System.monotonic_time(:microsecond))
  end
end
