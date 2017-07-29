defmodule Wechat.Message.Template do
  @moduledoc """
  Template Message API.

  ref: http://mp.weixin.qq.com/wiki/5/6dde9eaa909f83354e0094dc3ad99e05.html#.E5.8F.91.E9.80.81.E6.A8.A1.E6.9D.BF.E6.B6.88.E6.81.AF
  """

  alias Wechat.API

  @api_path "message/template/send"

  def send(openid, template_id, url, data) do
    body = %{
      "touser" => openid,
      "template_id" => template_id,
      "url" => url,
      "data" => data
    }

    API.post @api_path, body
  end
end
