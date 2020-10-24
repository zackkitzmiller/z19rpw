defmodule Z19rpwWeb.PageController do
  use Z19rpwWeb, :controller

  def index(conn, _params) do
    if conn.host == "thetrumphealthcareplan.com" do
      conn
      |> redirect(to: "/thc")
    else
      render(conn, "index.html")
    end
  end

  def thc(conn, _params) do
    conn
    |> put_layout("none.html")
    |> render("redirect.html")
  end

  def coffee(conn, _params) do
    render(conn, "coffee.html")
  end
end
