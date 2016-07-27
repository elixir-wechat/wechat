defmodule Wechat.Media do
  @moduledoc false

  import Wechat.ApiFile

  def download(media_id) do
    get "media/get", media_id: media_id
  end
end
