defmodule Wechat.Wxa do
  @moduledoc false

  import Wechat

  def jscode2session(client, js_code) do
    params = [
      appid: client.auth.appid,
      secret: client.auth.secret,
      js_code: js_code,
      grant_type: :authorization_code
    ]

    raw_get(client, "sns/jscode2session", params: params)
  end
end
