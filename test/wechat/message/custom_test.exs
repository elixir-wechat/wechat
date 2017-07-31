defmodule Wechat.Message.CustomTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.Message.Custom

  @openid "oi00OuKAhA8bm5okpaIDs7WmUZr4"

  setup_all do
    [openid: @openid]
  end

  test "send custom text", %{openid: openid} do
    use_cassette "send_custom_text" do
      result = Custom.send_text(openid, "hello from wechat-elixir")
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end
end