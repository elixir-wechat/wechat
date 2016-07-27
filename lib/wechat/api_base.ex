defmodule Wechat.ApiBase do
  @moduledoc false

  use HTTPoison.Base

  @base_url "https://api.weixin.qq.com/cgi-bin/"

  def process_url(path) do
    if String.starts_with?(path, "token") do
      @base_url <> path
    else
      @base_url <> path <> ~s(&access_token=#{Wechat.access_token})
    end
  end

  def process_response_body(body), do: Poison.decode!(body, keys: :atoms)

  def get(path, params \\ []) do
    __MODULE__.get!(path, [], params: params).body
  end
end
