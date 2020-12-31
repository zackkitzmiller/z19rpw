defmodule Z19rpwWeb.CDNHelpers do
  @moduledoc """
  Conveniences for generating URLs for assets in the CDN.
  """
  def signed_cdn_path(asset, opts \\ []) do
    opts = Keyword.put(opts, :expires_in, Keyword.get(opts, :expires_in, 60 * 10))

    {:ok, url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(:get, "public", asset, opts)

    # While the bucket is named "public" internalls, it's not exposed as such
    # It's exposed as "assets" to the common web. Let's replace that here.
    url |> String.replace("public", "assets")
  end

  def cdn_path(asset, opts \\ []) do
    opts = Keyword.put(opts, :expires_in, Keyword.get(opts, :expires_in, 60 * 10))

    {:ok, url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(:get, "public", asset, opts)

    url
    |> String.replace("public", "assets")
    |> URI.parse()
    |> struct(%{query: nil})
    |> URI.to_string()
  end
end
