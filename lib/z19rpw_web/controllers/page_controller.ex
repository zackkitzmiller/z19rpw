defmodule Z19rpwWeb.PageController do
  use Z19rpwWeb, :controller

  # alias Z19rpw.Static
  # alias Z19rpw.Static.Page

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
