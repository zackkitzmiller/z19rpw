defmodule Z19rpwWeb.UserControllerTest do
  use Z19rpwWeb.ConnCase

  alias Z19rpw.Accounts
  alias Z19rpw.Accounts.User

  @create_attrs %{
    password: "some hashed_password",
    permissions: %{default: [:read_users]},
    username: "some username"
  }
  @write_attrs %{
    password: "some write_user_password",
    permissions: %{default: [:read_users, :write_users]},
    username: "some write_user"
  }
  @update_attrs %{
    password: "some updated hashed_password",
    permissions: %{},
    username: "some updated username"
  }
  @invalid_attrs %{hashed_password: nil, permissions: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def fixture(:write_user) do
    {:ok, user} = Accounts.create_user(@write_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      user = fixture(:user)
      conn = conn |> authenticated(user)
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == [%{
        "id" => user.id,
        "ok_computer" => User.ok_computer?(user),
        "permissions" => %{"default" => ["read_users"]},
        "username" => user.username
      }]
    end

    test "fails with no token", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 401)["message"] == "unauthenticated"
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = conn |> recycle() |> authenticated(Accounts.get_user!(id))
      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "permissions" => %{},
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "fails valid data unauthorized", %{conn: conn, user: %User{} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert json_response(conn, 401)["message"] == "unauthenticated"
    end

    test "failed invalid data unauthorized", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 401)["message"] == "unauthenticated"
    end

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = conn |> authenticated(fixture(:write_user))
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "permissions" => %{},
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> authenticated(fixture(:write_user))
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "fails unauthenticated", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert json_response(conn, 401)["message"] == "unauthenticated"
    end

    test "fails on read user", %{conn: conn, user: user} do
      conn = conn |> authenticated(user)
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert json_response(conn, 401)["message"] == "unauthorized"
    end

    test "deleted on write user", %{conn: conn} do
      user = fixture(:write_user)
      conn = conn |> authenticated(user)
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end

  defp authenticated(conn, user) do
    {:ok, jwt, _full_claims} = Z19rpw.Guardian.encode_and_sign(user, %{}, permissions: user.permissions)
    conn |> put_req_header("authorization", "Bearer #{jwt}")
  end

end
