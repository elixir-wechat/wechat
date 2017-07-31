defmodule Wechat.MediaTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.Media

  test "upload image" do
    use_cassette "media_upload_image" do
      file = Path.expand("../../fixture/media_assets/elixir.png", __DIR__)
      result = Media.upload_image(file)
      assert Map.has_key?(result, "media_id")
      assert result["type"] == "image"
    end
  end
end