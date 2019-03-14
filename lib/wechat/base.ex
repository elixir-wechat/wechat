defmodule Wechat.Base do
  @moduledoc false

  import Wechat

  def token(client) do
    params = [
      appid: client.auth.appid,
      secret: client.auth.secret,
      grant_type: :client_credential
    ]

    raw_get(client, "cgi-bin/token", params: params)
  end
end
