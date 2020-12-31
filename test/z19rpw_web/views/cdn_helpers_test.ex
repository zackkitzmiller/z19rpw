defmodule Z19rpwWeb.CDNHelpersTest do
  @moduledoc """
  Test for any authentication related helper files
  """
  use Z19rpwWeb.ConnCase, async: true

  alias Z19rpwWeb.CDNHelpers

  describe "cdn helper" do
    test "signed_cdn_path/2 correctly generates a url" do
      assert %URI{
               :authority => "contentdeliverynetwork.z19r.pw",
               :host => "contentdeliverynetwork.z19r.pw",
               :fragment => nil,
               :port => 443,
               :query => _,
               :userinfo => _,
               :path => "/assets/asset.png"
             } = URI.parse(CDNHelpers.signed_cdn_path("asset.png"))
    end

    test "cdn_path/2 correctly generates a url" do
      assert "https://contentdeliverynetwork.z19r.pw/assets/asset.png" =
               CDNHelpers.cdn_path("asset.png")
    end
  end
end
