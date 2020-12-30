defmodule Z19rpwWeb.AuthRouteHelpers do
  @moduledoc """
  Helpers for handling URL redirections WRT authentication
  """

  alias Z19rpwWeb.Router.Helpers, as: Routes

  def login_to_current_path(conn) do
    case conn.request_path do
      "/" ->
        Routes.pow_session_path(conn, :new)

      _ ->
        Routes.pow_session_path(conn, :new) <> "?request_path=" <> conn.request_path
    end
  end
end
