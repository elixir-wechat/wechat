defmodule Wechat.Menu do
  @moduledoc """
  Menu APIs.
  """

  alias Wechat.Request

  @doc """
  Create menu.
  """
  def create(client, menu) do
    Request.post(client, "cgi-bin/menu/create", menu)
  end

  @doc """
  Get menu.
  """
  def get(client) do
    Request.get(client, "cgi-bin/menu/get")
  end

  @doc """
  Delete menu.
  """
  def delete(client) do
    Request.get(client, "cgi-bin/menu/delete")
  end

  @doc """
  Add conditional menu.
  """
  def add_conditional(client, menu) do
    Request.post(client, "cgi-bin/menu/addconditional", menu)
  end

  @doc """
  Delete conditional menu.
  """
  def delete_conditional_menu(client, menu_id) do
    Request.post(client, "cgi-bin/menu/delconditional", %{menuid: menu_id})
  end

  @doc """
  Match user with menus to see which menu is available to the user.
  """
  def try_match(client, openid) do
    Request.post(client, "cgi-bin/menu/trymatch", %{user_id: openid})
  end

  @doc """
  Get menu set by create menu API.
  """
  def get_current_selfmenu_info(client) do
    Request.get(client, "cgi-bin/get_current_selfmenu_info")
  end
end
