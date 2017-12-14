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

  @keys ~w(appid secret token encoding_aes_key)a

  for key <- @keys do
    def unquote(key)() do
      get_env(config()[unquote(key)])
    end
  end

  defp get_env({:system, env_var}) do
    System.get_env(env_var)
  end
  defp get_env(val) do
    val
  end
end
