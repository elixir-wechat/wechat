defmodule Wechat.AccessToken do
  @moduledoc false

  import Wechat.ApiBase

  def token do
    get "token",
      grant_type: "client_credential",
      appid: Wechat.config[:appid],
      secret: Wechat.config[:secret]
  end
end
