defmodule Wechat.SNS do
  @moduledoc false

  use Wechat.HTTP, host: Wechat.config[:sns_host]

  def jscode2session(code) do
    get "jscode2session", %{
      appid: Wechat.appid,
      secret: Wechat.secret,
      js_code: code,
      grant_type: "authorization_code",
    }
  end
end
