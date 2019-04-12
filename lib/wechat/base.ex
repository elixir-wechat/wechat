defmodule Wechat.Base do
  @moduledoc false

  alias Wechat.Request

  def token(client) do
    params = [
      appid: client.auth.appid,
      secret: client.auth.secret,
      grant_type: :client_credential
    ]

    Request.raw_get(client, "cgi-bin/token", params: params)
  end
end
