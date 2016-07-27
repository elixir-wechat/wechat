defmodule Wechat.ApiFile do
  @moduledoc false

  use HTTPoison.Base
  alias HTTPoison.Response

  @base_url "http://file.api.weixin.qq.com/cgi-bin/"

  def process_url(path) do
    @base_url <> path <> ~s(&access_token=#{Wechat.access_token})
  end

  def process_response(%Response{headers: headers, body: body}) do
    content_type = :proplists.get_value("Content-Type", headers)
    if content_type in ["application/json", "text/plain"] do
      Poison.decode!(body, keys: :atoms)
    else
      body
    end
  end

  def get(path, params \\ []) do
    __MODULE__.get!(path, [], params: params)
    |> process_response
  end
end
