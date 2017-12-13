defmodule Wechat.Config do
  @moduledoc false

  @default_config [
    api_host: "https://api.weixin.qq.com/cgi-bin",
    sns_host: "https://api.weixin.qq.com/sns",
    mp_host: "https://mp.weixin.qq.com/cgi-bin",
  ]

  def config do
    Keyword.merge(@default_config, Application.get_all_env(:wechat))
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

  defp get_env({:system, env_var}) do
    System.get_env(env_var)
  end
  defp get_env(val) do
    val
  end
end
