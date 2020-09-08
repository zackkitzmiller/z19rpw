defmodule Z19rpwWeb.RadioheadLive do
  use Z19rpwWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :ok, 'computer')}
  end

  def render(assigns) do
    ~L"""
    <button phx-click="compute"><%= @ok %></button>
    """
  end

  def handle_event("compute", _, socket) do
    socket = assign(socket, :ok, "r-a-i-d-i-o-h-e-a-d-md5")
    {:noreply, socket}
  end
end
