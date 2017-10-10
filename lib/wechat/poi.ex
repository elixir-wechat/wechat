defmodule Wechat.POI do
  @moduledoc """
  POI API.
  ref: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1444378120
  """

  alias Wechat.API

  # 注意：经纬度坐标需要转换为腾讯地图坐标。
  # http://lbs.qq.com/webservice_v1/guide-convert.html
  def add(data) do
    API.post("/poi/addpoi", data)
  end

  def get(id) do
    API.post("/poi/getpoi", %{poi_id: id})
  end

  def get_list(begin, limit) when is_integer(limit) and is_integer(begin) do
    API.post("/poi/getpoilist", %{ begin: begin, limit: limit})
  end

  def delete(id) do
    API.post("/poi/delpoi", %{poi_id: id})
  end

  # 以上8个字段，若有填写内容则为覆盖更新，若无内容则视为不修改，维持原有内容。
  # photo_list 字段为全列表覆盖，若需要增加图片，需将之前图片同样放入list 中，在其后增加新增图片。
  # 如：已有A、B、C 三张图片，又要增加D、E 两张图，则需要调用该接口，photo_list 传入A、B、C、D、E 五张图片的链接。
  def update(data) when is_map(data) do
    API.post("/poi/updatepoi", data)
  end

  def get_wxcategory do
    API.get("/poi/getwxcategory")
  end
end
