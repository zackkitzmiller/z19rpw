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

  test "vaccine renders", %{conn: conn} do
    conn = get(conn |> struct(%{host: "shouldigetthecovidvaccine.com"}), "/")
    assert html_response(conn, 200) =~ "<title>should i get the covid vaccine</title>"
  end

  test "404 renders html", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, "/this-isnt-a-page")
    end
  end
end
