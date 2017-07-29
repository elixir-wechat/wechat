defmodule Wechat.User do
  @moduledoc false

  alias Wechat.API

  def get(next_openid \\ "") do
    API.get "/user/get", %{
      next_openid: next_openid
    }
  end

  def info(openid, lang \\ "zh_CN") do
    API.get "/user/info", %{
      openid: openid,
      lang: lang
    }
  end

  def update_remark(openid, remark) do
    API.post "/user/info/updateremark", %{
      openid: openid,
      remark: remark
    }
  end
end