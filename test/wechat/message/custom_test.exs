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

  test "send link", %{openid: openid} do
    use_cassette "send_link" do
      result = Custom.send_link(openid, %{
        title: "Awesome webpage",
        description: "Click and you will go",
        url: "http://www.example.com",
        thumb_url: "https://gitlab.com/gitlab-com/gitlab-artwork/raw/master/logo/logo.png"
      })
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end

  test "send weapp page", %{openid: openid} do
    use_cassette "send_mini_program_app_page" do
      result = Custom.send_mini_program_app_page(openid, %{
        title: "my mini program app",
        pagepath: "/pages/index?id=1",
        thumb_media_id: "111"
      })
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end
end
