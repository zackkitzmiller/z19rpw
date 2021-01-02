defmodule Z19rpwWeb.Pow.Routes do
  @moduledoc """
  handle callbacks for Pow routes
  """
  use Pow.Phoenix.Routes
  alias Z19rpwWeb.Router.Helpers, as: Routes

  def after_registration_path(conn), do: Routes.pow_session_path(conn, :new)
end
