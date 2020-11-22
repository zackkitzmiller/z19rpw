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

    setup %{conn: conn} do
      user = %Z19rpw.Users.User{email: "test@example.com", id: 1}
      authed_conn = Pow.Plug.assign_current_user(conn, user, [])

      {:ok, conn: conn, authed_conn: authed_conn}
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

    test "shows loging screen if not authed", %{conn: conn} do
      post = post_fixture()
      conn = get(conn, "/posts/creating-new-things/edit")
      # assert redirected_to(conn) == Routes.post_show_path(conn, :edit, post.slug)
      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, %{
                 "request_path" => Routes.post_show_path(conn, :edit, post.slug)
               })

      {:error, _} = live(conn)
    end

    test "edit form shown if authed", %{authed_conn: authed_conn} do
      post_fixture()

      authed_conn = get(authed_conn, "/posts/creating-new-things/edit")
      # for now having a form tag is sufficient to make sure the page is here
      assert html_response(authed_conn, 200) =~ "<form action"
      assert html_response(authed_conn, 200) =~ "Creating New Things"

      {:ok, _, _} = live(authed_conn)
    end
  end
end
