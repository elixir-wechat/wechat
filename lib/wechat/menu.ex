defmodule Wechat.Menu do
  @moduledoc """
  Menu API.
  """

  alias Wechat.API

  def create(menu) do
    API.post("/menu/create", menu)
  end

  def get do
    API.get("/menu/get")
  end

  def delete do
    API.get("/menu/delete")
  end

  def create_conditional(menu)  do
    API.post("/menu/addconditional", menu)
  end

  def delete_conditional(menu_id) do
    API.post("/menu/delconditional", %{"menuid" => menu_id})
  end

  def try_match(user_id) do
    API.post("/menu/trymatch", %{"user_id" => user_id})
  end

  def get_self_menu do
    API.get("/get_current_selfmenu_info")
  end
end
