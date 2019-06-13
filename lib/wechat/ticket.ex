defmodule Wechat.Ticket do
  @moduledoc false

  alias Wechat.Request

  def get_ticket(client, type) when type in [:jsapi, :wx_card],
    do: Request.get(client, "cgi-bin/ticket/getticket", params: [type: type])

  def jsapi_ticket(client), do: get_ticket(client, :jsapi)

  def wxcard_ticket(client), do: get_ticket(client, :wx_card)
end
