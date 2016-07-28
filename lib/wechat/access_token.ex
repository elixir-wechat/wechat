defmodule Wechat.AccessToken do
  @moduledoc """
  AccessToken API.
  """

  import Wechat.ApiBase

  def token do
    get "token",
      grant_type: "client_credential",
      appid: Wechat.config[:appid],
      secret: Wechat.config[:secret]
  end
end
