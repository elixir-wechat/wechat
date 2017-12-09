defmodule Wechat.API do
  @moduledoc false

  use Wechat.HTTP, host: Wechat.config[:api_host]

  def access_token do
    get "/token", %{
      grant_type: :client_credential,
      appid: Wechat.appid,
      secret: Wechat.secret,
    }
  end

  def clear_quota do
    post "/clear_quota", %{
      appid: Wechat.appid
    }
  end

  def upload(url, file, params \\ %{}) do
    post url, {:multipart, [{:file, file}]}, params
  end

  def download(url, params \\ %{}) do
    get url, params
  end
end
