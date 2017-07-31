defmodule Wechat.Ticket do
  @moduledoc false

  alias Wechat.API

  def jsapi_ticket, do: API.get "/ticket/getticket", %{type: :jsapi}
  def api_ticket, do: API.get "/ticket/getticket", %{type: :wx_card}
end
