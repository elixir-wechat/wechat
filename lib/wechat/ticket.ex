defmodule Wechat.Ticket do
  @moduledoc """
  Ticket APIs.
  """

  alias Wechat.Request

  @doc """
  Get ticket API by type.
  """
  def get_ticket(client, type) when type in [:jsapi, :wx_card],
    do: Request.get(client, "cgi-bin/ticket/getticket", params: [type: type])

  @doc """
  Get jsapi ticket.
  """
  def jsapi_ticket(client), do: get_ticket(client, :jsapi)

  @doc """
  Get wxcard ticket.
  """
  def wxcard_ticket(client), do: get_ticket(client, :wx_card)
end
