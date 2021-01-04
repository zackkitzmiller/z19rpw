defmodule Z19rpwWeb.FormComponentTest do
  @moduledoc """
  Test module for the Blog LiveView controllers and interactions
  """
  use Z19rpwWeb.ConnCase, async: true

  # import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import Z19rpwWeb.PostLive.FormComponent

  alias Z19rpw.Blog
  alias Z19rpw.Users.User
  alias Z19rpw.Repo

  @password "secret1234"

  def user_fixture do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: @password,
        username: "this-is-a-fun-name",
        password_confirmation: @password
      })
      |> Repo.insert!()

    user |> struct(%{password: nil})
  end

  describe "post form" do
    @valid_attrs %{user: 42, body: "some body", title: "Creating New Things"}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post(user_fixture())

      post |> Z19rpw.Repo.preload([:likes, :user])
    end

    setup %{conn: conn} do
      user = %User{email: "test@example.com", id: 1}
      authed_conn = Pow.Plug.assign_current_user(conn, user, [])

      {:ok, conn: conn, authed_conn: authed_conn}
    end

    test "handles simple validation", %{conn: conn} do
      assert {:noreply, _} =
               handle_event(
                 "validate",
                 %{"post" => %{:post => %{:body => "body", :title => "title"}}},
                 %Phoenix.LiveView.Socket{
                   :assigns => %{:post => %Blog.Post{:body => "bodasdfy", :title => "titasdfle"}}
                 }
               )
    end

    # test "handles simple validation", %{conn: conn} do
    #   assert {:noreply, _} =
    #            handle_event(
    #              "validate",
    #              %{"post" => %{:post => %{:body => "body", :title => "title"}}},
    #              %Phoenix.LiveView.Socket{
    #                :assigns => %{:post => %Blog.Post{:body => "bodasdfy", :title => "titasdfle"}}
    #              }
    #            )
    # end
  end
end
