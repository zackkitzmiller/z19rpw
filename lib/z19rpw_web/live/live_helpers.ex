defmodule Z19rpwWeb.LiveHelpers do
  @moduledoc false
  import Phoenix.LiveView.Helpers

  def live_modal(_socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(_socket, Z19rpwWeb.ModalComponent, modal_opts)
  end
end
