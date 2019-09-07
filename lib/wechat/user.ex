defmodule Wechat.User do
  @moduledoc """
  User APIs.
  """

  alias Wechat.Request

  @doc """
  List users.
  获取用户列表。
  """
  def get(client, next_openid \\ "") do
    params = [next_openid: next_openid]
    Request.get(client, "cgi-bin/user/get", params: params)
  end

  @doc """
  Get details of user.
  获取用户基本信息。
  """
  def info(client, openid, lang \\ "zh_CN") do
    params = [openid: openid, lang: lang]
    Request.get(client, "cgi-bin/user/info", params: params)
  end

  @doc """
  Set remark for user.
  设置用户备注名。
  """
  def update_remark(client, openid, remark) do
    body = %{openid: openid, remark: remark}
    Request.post(client, "cgi-bin/user/info/updateremark", body)
  end
end
