defmodule Z19rpwWeb.PageController do
  use Z19rpwWeb, :controller

  def index(conn, _params) do
    case conn.host do
      "thetrumphealthcareplan.com" ->
        conn
        |> redirect(to: "/thc")

      "shouldigetthecovidvaccine.com" ->
        render(conn |> put_layout(false), "vaccine.html")

      _ ->
        render(conn, "index.html")
    end
  end

  def thc(conn, _params) do
    conn
    |> redirect(external: "https://www.nytimes.com/2020/11/07/us/politics/biden-election.html")
  end

  def coffee(conn, _params) do
    conn =
      conn
      |> assign(:page_title, "let's get coffee")

    render(conn, "coffee.html")
  end

  def err(_conn, _params) do
    raise "Error"
  end
end
