defmodule Z19rpwWeb.PageController do
  use Z19rpwWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
