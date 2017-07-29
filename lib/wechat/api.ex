defmodule Wechat.API do
  @moduledoc false

  use Wechat.HTTP, host: Wechat.config[:api_host]

  def get(url, params \\ %{}) do
    get!(url, [], params: params).body
  end

  def post(url, body, params \\ %{}) do
    post!(url, Poison.encode!(body), [], params: params).body
  end

  def upload(url, file, params \\ %{}) do
    post!(url, {:multipart, [{:file, file}]}, [], params: params).body
  end

  def download(url, params \\ %{}) do
    get!(url, [], params: params).body
  end

  def access_token do
    get "/token", %{
      grant_type: :client_credential,
      appid: Wechat.appid,
      secret: Wechat.secret,
    }
  end
end