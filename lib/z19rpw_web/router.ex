defmodule Z19rpwWeb.Router do
  use Z19rpwWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
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
  end

  scope "/", Z19rpwWeb do
    pipe_through [:browser, :protected]

    live "/posts/new", PostLive.Index, :new, layout: {Z19rpwWeb.LayoutView, "app.html"}
    live "/posts/:id/edit", PostLive.Index, :edit, layout: {Z19rpwWeb.LayoutView, "app.html"}

    live "/posts/:slug/show/edit", PostLive.Show, :edit,
      layout: {Z19rpwWeb.LayoutView, "app.html"}
  end

  scope "/", Z19rpwWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/thc", PageController, :thc
    get "/coffee", PageController, :coffee
    get "/mentorship", PageController, :mentoring

    live "/blog", PostLive.Index, :index, layout: {Z19rpwWeb.LayoutView, "app.html"}
    live "/posts/:slug", PostLive.Show, :show, layout: {Z19rpwWeb.LayoutView, "app.html"}
  end

  scope "/api", Z19rpwWeb do
    resources "/posts", PostController, except: [:new, :edit]
  end

  import Phoenix.LiveDashboard.Router

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
