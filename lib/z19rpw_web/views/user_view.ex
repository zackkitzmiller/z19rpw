defmodule Z19rpwWeb.UserView do
  use Z19rpwWeb, :view
  alias Z19rpwWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      permissions: user.permissions,
      ok_computer: user.id == 1}
  end
end
