defmodule Wechat.UserTest do
  use WechatBypass.Case, async: true

  import Wechat.User

  @tag bypass_api: %{
         method: "GET",
         path: "/cgi-bin/user/get",
         status_code: 200,
         use_fixture: true
       }
  test "get/2", %{client: client} do
    {:ok, body} = get(client)
    assert %{"count" => _, "total" => _, "data" => %{}, "next_openid" => _} = body
  end

  @tag bypass_api: %{
         method: "GET",
         path: "/cgi-bin/user/info",
         status_code: 200,
         use_fixture: true
       }
  test "info/3", %{client: client} do
    openid = "o6_bmjrPTlm6_2sgVt7hMZOPfL2M"
    {:ok, body} = info(client, openid)
    assert %{"openid" => ^openid, "nickname" => _} = body
  end

  @tag bypass_api: %{
         method: "POST",
         path: "/cgi-bin/user/info/updateremark",
         status_code: 200,
         use_fixture: true
       }
  test "update_remark/3", %{client: client} do
    {:ok, body} = update_remark(client, "test_openid", "VIP")
    assert %{"errcode" => 0, "errmsg" => "ok"} = body
  end
end
