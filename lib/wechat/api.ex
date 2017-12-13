defmodule Wechat.API do
  @moduledoc false

  alias Wechat.Config

  use Wechat.HTTP, host: Config.config[:api_host]

  def access_token do
    get "/token", %{
      grant_type: :client_credential,
      appid: Config.appid,
      secret: Config.secret,
    }
  end

  def clear_quota do
    post "/clear_quota", %{
      appid: Config.appid
    }
  end

  def upload(url, file, params \\ %{}) do
    post url, {:multipart, [{:file, file}]}, params
  end

  def download(url, params \\ %{}) do
    get url, params
  end
end
