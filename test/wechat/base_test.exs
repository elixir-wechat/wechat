defmodule Wechat.BaseTest do
  use WechatBypass.Case, async: true

  import Wechat.Base

  @tag bypass_api: %{
         method: "GET",
         path: "/cgi-bin/token",
         status_code: 200,
         use_fixture: true
       }
  test "token/1", %{client: client} do
    {:ok, body} = token(client)
    assert %{"access_token" => _} = body
  end

  @tag bypass_api: %{
         method: "GET",
         path: "/cgi-bin/token",
         status_code: 200,
         response_body: ~S({"errcode": 40001, "errmsg": "access_token expired"})
       }
  test "token/1 returns API error", %{client: client} do
    {:error, error} = token(client)
    assert %{type: :api, code: 40_001, reason: "access_token expired"} = error
  end

  @tag bypass_api: %{
         method: "GET",
         path: "/cgi-bin/token",
         status_code: 404
       }
  test "token/1 raises HTTP error", %{client: client} do
    assert_raise(Wechat.Error, ~r/HTTP error: 404/, fn ->
      token(client)
    end)
  end
end
