defmodule Z19rpw.Cachier do
  use Decorator.Define, write_through: 0
  require Logger

  def write_through(body, context) do
    key = cache_key(context)
    quote do
      key = unquote(key)
      case Memcachir.get(key) do
        {:ok, resp} ->
          Logger.info("found key: " <> key <> " in cache.")
          resp

        {:error, message} ->
          Logger.info(message)
          resp = unquote(body)
          Memcachir.set(key, resp, ttl: 300)
          resp
      end
    end
  end

  defp cache_key(context) do
    quote do
      Atom.to_string(unquote(context.module))
        <> Atom.to_string(unquote(context.name))
        <> Macro.to_string(unquote(context.args))
          |> String.downcase()
          |> String.replace(~r/[^a-z0-9\s-]/, "-")
          |> String.replace(~r/(\s|-)+/, ":")
    end
  end
end
