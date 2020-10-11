defmodule Z19rpwWeb.StatusController do
  use Z19rpwWeb, :controller

  def status(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
