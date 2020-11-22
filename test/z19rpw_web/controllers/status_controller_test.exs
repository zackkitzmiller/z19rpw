defmodule Z19rpwWeb.StatusControllerTest do
  use Z19rpwWeb.ConnCase

  describe "status" do
    test "runns with app isup", %{conn: conn} do
      conn = get(conn, "/_status")
      assert %{"status" => "ok"} == json_response(conn, 200)
    end
  end
end
