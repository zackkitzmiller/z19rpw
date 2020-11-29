defmodule Z19rpwWeb.APIAuthErrorHandler do
  @moduledoc false

  use Z19rpwWeb, :controller
  alias Plug.Conn

  @spec call(Conn.t(), :not_authenticated) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: "uh uh uh. you didnt say the magic word"}})
  end
end
