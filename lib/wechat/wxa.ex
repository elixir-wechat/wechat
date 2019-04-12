defmodule Wechat.Wxa do
  @moduledoc false

  alias Wechat.Request

  def jscode2session(client, js_code) do
    params = [
      appid: client.appid,
      secret: client.secret,
      js_code: js_code,
      grant_type: :authorization_code
    ]

    Request.raw_get(client, "sns/jscode2session", params: params)
  end
end
