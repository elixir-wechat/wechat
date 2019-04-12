defmodule Wechat.User do
  @moduledoc false

  alias Wechat.Request

  def get(client, next_openid \\ "") do
    params = [next_openid: next_openid]
    Request.get(client, "cgi-bin/user/get", params: params)
  end

  def info(client, openid, lang \\ "zh_CN") do
    params = [openid: openid, lang: lang]
    Request.get(client, "cgi-bin/user/info", params: params)
  end

  def update_remark(client, openid, remark) do
    body = %{openid: openid, remark: remark}
    Request.post(client, "cgi-bin/user/info/updateremark", body)
  end
end
