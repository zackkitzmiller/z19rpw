# sentry_event_filter.ex
defmodule Z19rpw.SentryEventFilter do
  @moduledoc """
  Custom handler for filtering 404 Errors
  """
  @behaviour Sentry.EventFilter

  def exclude_exception?(%Elixir.Phoenix.Router.NoRouteError{}, :plug), do: true
  def exclude_exception?(%Ecto.NoResultsError{}, :plug), do: true
  def exclude_exception?(_exception, _source), do: false
end
