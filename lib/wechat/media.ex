defmodule Wechat.Media do
  @moduledoc false

  alias Wechat.API

  def upload_image(file) do
    API.upload "/media/upload", file, %{type: :image}
  end

  def upload_voice(file) do
    API.upload "/media/upload", file, %{type: :voice}
  end

  def upload_video(file) do
    API.upload "/media/upload", file, %{type: :video}
  end

  def upload_thumb(file) do
    API.upload "/media/upload", file, %{type: :thumb}
  end

  def get(media_id) do
    API.download "/media/get", %{media_id: media_id}
  end
end