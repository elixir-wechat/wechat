defmodule Wechat.User do
  @moduledoc """
  User API.
  """

  import Wechat.ApiBase

  def list do
    get "user/get"
  end

  def list(next_openid) do
    get "user/get", next_openid: next_openid
  end

  def info(openid) do
    get "user/info", openid: openid
  end
end
