defmodule Wechat.Merchant do
  @moduledoc """
  Wechat merchant api.
  ref: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1496904104_cfEfT
  """

  use Wechat.HTTP, host: "https://api.weixin.qq.com/wxa/"

  def get do
    get("/get_merchant_category")
  end

  def create(params) when is_map(params) do
    post("/apply_merchant", params)
  end

  def get_audit_info do
    get("/get_merchant_audit_info")
  end

  def modify(intro, media_id) do
    post("/modify_merchant", %{
      intro: intro,
      headimg_mediaid: media_id
    })
  end

  def get_district do
    get("/get_district")
  end

  def create_map_poi(params) when is_map(params) do
    post("/create_map_poi", params)
  end

  def add_store(params, poi_id \\ nil, map_poi_id \\ nil) when is_map(params) do
    params =
      params
      |> maybe_put_in(:poi_id, poi_id)
      |> maybe_put_in(:map_poi_id, map_poi_id)

    post("/add_store", params)
  end

  def update_store(params, poi_id \\ nil, map_poi_id \\ nil) when is_map(params) do
    params =
      params
      |> maybe_put_in(:poi_id, poi_id)
      |> maybe_put_in(:map_poi_id, map_poi_id)

    post("/add_store", params)
  end

  def get_store(poi_id) do
    post("/get_store_info", %{poi_id: poi_id})
  end

  def get_store_list(offset, limit) when is_integer(offset) and is_integer(limit) do
    post("get_store_list", %{offset: offset, limit: limit})
  end

  def delete_store(poi_id) do
    post("/del_store", %{poi_id: poi_id})
  end

  # TODO
  def migrate_from_poi do
  end

  # TODO
  def set_cards do
  end

  defp maybe_put_in(params, _id, nil),                    do: params
  defp maybe_put_in(params, _id, ""),                     do: params
  defp maybe_put_in(params, id, val) when is_binary(val), do: Map.put(params, id, val)
end
