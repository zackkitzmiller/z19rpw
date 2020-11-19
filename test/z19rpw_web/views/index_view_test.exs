defmodule Z19rpwWeb.IndexViewTest do
  use Z19rpwWeb.ConnCase, async: true

  import Phoenix.ConnTest

  test "home renders", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<title>z19r</title>"
  end

  test "coffee renders", %{conn: conn} do
    conn = get(conn, "/coffee")
    assert html_response(conn, 200) =~ "<title>z19r - let's get coffee</title>"
  end
end
