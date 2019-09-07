defmodule Wechat.QRCode do
  @moduledoc """
  QRCode APIs.
  """

  alias Wechat.Request

  @doc """
  Create qrcode with scene and expire time.
  """
  def create(client, scene_id, expire_seconds) when is_integer(scene_id) do
    Request.post(client, "cgi-bin/qrcode/create", %{
      action_name: "QR_SCENE",
      action_info: %{scene: %{scene_id: scene_id}},
      expire_seconds: expire_seconds
    })
  end

  def create(client, scene_str, expire_seconds) when is_binary(scene_str) do
    Request.post(client, "cgi-bin/qrcode/create", %{
      action_name: "QR_STR_SCENE",
      action_info: %{scene: %{scene_str: scene_str}},
      expire_seconds: expire_seconds
    })
  end

  def create(client, scene_id) when is_integer(scene_id) do
    Request.post(client, "cgi-bin/qrcode/create", %{
      action_name: "QR_LIMIT_SCENE",
      action_info: %{scene: %{scene_id: scene_id}}
    })
  end

  def create(client, scene_str) when is_binary(scene_str) do
    Request.post(client, "cgi-bin/qrcode/create", %{
      action_name: "QR_LIMIT_STR_SCENE",
      action_info: %{scene: %{scene_str: scene_str}}
    })
  end
end
