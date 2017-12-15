defmodule Wechat.QRCodeTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.QRCode

  test "create temporary qrcode with scene_id" do
    use_cassette "qrcode_create_temporary_with_scene_id" do
      result = QRCode.create(100, 3600)
      assert result["expire_seconds"] == 3600
      assert Map.has_key?(result, "ticket")
      assert Map.has_key?(result, "url")
    end
  end

  test "create temporary qrcode with scene_str" do
    use_cassette "qrcode_create_temporary_with_scene_str" do
      result = QRCode.create("elixir meetup", 7200)
      assert result["expire_seconds"] == 7200
      assert Map.has_key?(result, "ticket")
      assert Map.has_key?(result, "url")
    end
  end

  test "create permanent qrcode with scene_id" do
    use_cassette "qrcode_create_permanent_with_scene_id" do
      result = QRCode.create(101)
      assert Map.has_key?(result, "ticket")
      assert Map.has_key?(result, "url")
    end
  end

  test "create permanent qrcode with scene_str" do
    use_cassette "qrcode_create_permanent_with_scene_str" do
      result = QRCode.create("elixir china meetup")
      assert Map.has_key?(result, "ticket")
      assert Map.has_key?(result, "url")
    end
  end
end
