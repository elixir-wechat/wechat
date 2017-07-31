defmodule Wechat.QRCode do
  @moduledoc false

  alias Wechat.API

  def create(scene_id, expire_seconds) when is_integer(scene_id) do
    API.post "/qrcode/create", %{
      expire_seconds: expire_seconds,
      action_name: "QR_SCENE",
      action_info: %{scene: %{scene_id: scene_id}}
    }
  end
  def create(scene_str, expire_seconds) when is_binary(scene_str) do
    API.post "/qrcode/create", %{
      expire_seconds: expire_seconds,
      action_name: "QR_STR_SCENE",
      action_info: %{scene: %{scene_str: scene_str}}
    }
  end
  def create(scene_id) when is_integer(scene_id) do
    API.post "/qrcode/create", %{
      action_name: "QR_LIMIT_SCENE",
      action_info: %{scene: %{scene_id: scene_id}}
    }
  end
  def create(scene_str) when is_binary(scene_str) do
    API.post "/qrcode/create", %{
      action_name: "QR_LIMIT_STR_SCENE",
      action_info: %{scene: %{scene_str: scene_str}}
    }
  end
end
