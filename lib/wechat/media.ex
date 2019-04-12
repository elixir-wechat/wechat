defmodule Wechat.Media do
  @moduledoc false

  alias Wechat.Request

  @media_types [:image, :thumb, :voice, :video]

  def upload(client, file, type) when type in @media_types do
    body = {:multipart, [{:file, file}]}
    Request.post(client, "cgi-bin/media/upload", body, params: [type: type])
  end

  def get(client, media_id) do
    Request.get(client, "cgi-bin/media/get", params: [media_id: media_id])
  end
end
