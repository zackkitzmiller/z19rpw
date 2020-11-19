defmodule Z19rpwWeb.BlogViewTest do
  use Z19rpwWeb.ConnCase, async: true

  # import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias Z19rpw.Blog

  describe "posts" do
    @valid_attrs %{author: 42, body: "some body", title: "Creating New Things"}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
    end

    test "blog home renders", %{conn: conn} do
      conn = get(conn, "/blog")
      assert html_response(conn, 200) =~ "<title>z19r - blog</title>"

      {:ok, _, _} = live(conn)
    end

    test "psot view title is correct", %{conn: conn} do
      post_fixture()
      conn = get(conn, "/posts/creating-new-things")
      assert html_response(conn, 200) =~ "<title>z19r - Creating New Things</title>"

      {:ok, _, _} = live(conn)
    end
  end
end
