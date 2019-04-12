defmodule Wechat.Menu do
  @moduledoc false

  alias Wechat.Request

  def create(client, menu) do
    Request.post(client, "cgi-bin/menu/create", menu)
  end

  def get(client) do
    Request.get(client, "cgi-bin/menu/get")
  end

  def delete(client) do
    Request.get(client, "cgi-bin/menu/delete")
  end

  def add_conditional(client, menu) do
    Request.post(client, "cgi-bin/menu/addconditional", menu)
  end

  def delete_conditional_menu(client, menu_id) do
    Request.post(client, "cgi-bin/menu/delconditional", %{menuid: menu_id})
  end

  def try_match(client, user_id) do
    Request.post(client, "cgi-bin/menu/trymatch", %{user_id: user_id})
  end

  def get_current_selfmenu_info(client) do
    Request.get(client, "cgi-bin/get_current_selfmenu_info")
  end
end
