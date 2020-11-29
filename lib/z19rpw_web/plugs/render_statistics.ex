defmodule Z19rpwWeb.RenderStatistics do
  @moduledoc false

  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    assign(conn, :hostname, System.get_env("HOSTNAME"))
  end
end
