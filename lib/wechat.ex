defmodule Wechat do
  @moduledoc false

  alias Wechat.Workers.AccessToken
  alias Wechat.Workers.JSAPITicket

  def config do
    Keyword.merge(default_config(), Application.get_env(:wechat, Wechat))
  end

  def appid do
    config()[:appid] |> get_env
  end

  def secret do
    config()[:secret] |> get_env
  end

  def token do
    config()[:token] |> get_env
  end

  def encoding_aes_key do
    config()[:encoding_aes_key] |> get_env
  end

  defp default_config do
    [
      api_host: "https://api.weixin.qq.com/cgi-bin",
      mp_host: "https://mp.weixin.qq.com/cgi-bin"
    ]
  end

  defp get_env({:system, env_var}) do
    System.get_env(env_var)
  end
  defp get_env(val) do
    val
  end

  defdelegate access_token, to: AccessToken, as: :get
  defdelegate jsapi_ticket, to: JSAPITicket, as: :get
end
