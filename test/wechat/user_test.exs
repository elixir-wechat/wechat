defmodule Wechat.UserTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.User

  @openid "oi00OuKAhA8bm5okpaIDs7WmUZr4"

  setup_all do
    [openid: @openid]
  end

  test "user list" do
    use_cassette "user_get" do
      result = User.get
      assert Map.has_key?(result, "total")
      assert Map.has_key?(result, "count")
      assert Map.has_key?(result, "data")
    end
  end

  test "user info", %{openid: openid} do
    use_cassette "user_info" do
      result = User.info(openid)
      assert result["openid"] == openid
    end
  end

  test "update user remark", %{openid: openid} do
    use_cassette "user_updateremark" do
      result = User.update_remark(openid, "elixir man")
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
    end
  end
end
