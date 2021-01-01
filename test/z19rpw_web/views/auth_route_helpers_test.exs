defmodule Z19rpwWeb.AuthRouteHelpersTest do
  @moduledoc """
  Test for any authentication related helper files
  """
  use Z19rpwWeb.ConnCase, async: true

  alias Z19rpwWeb.AuthRouteHelpers

  describe "auth route heler login_to_current_path" do
    test "routes to a login page that redirects back to the current path", %{conn: conn} do
      conn = get(conn, "/coffee")
      assert "/session/new?request_path=/coffee" == AuthRouteHelpers.login_to_current_path(conn)
    end

    test "routes to a login page that redirects back to the home path", %{conn: conn} do
      conn = get(conn, "/")
      assert "/session/new" == AuthRouteHelpers.login_to_current_path(conn)
    end
  end
end
