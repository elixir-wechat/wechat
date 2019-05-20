defmodule Wechat.Ticket do
  @moduledoc false

  alias Wechat.Request

  def get_ticket(client, type) when type in [:jsapi, :wx_card],
    do: Request.get(client, "cgi-bin/ticket/getticket", params: [type: type])

  def jsapi_ticket(client), do: get_ticket(client, :jsapi)

  def wxcard_ticket(client), do: get_ticket(client, :wx_card)

  def sign_jsapi(client, url) do
    timestamp = Wechat.Util.unix_now()
    nonce = Base.url_encode64(:crypto.strong_rand_bytes(32), padding: false)

    {:ok, %{"ticket" => ticket}} = Wechat.Ticket.get_ticket(client, :jsapi)
    params = %{jsapi_ticket: ticket, noncestr: nonce, timestamp: timestamp, url: url}

    signature =
      params
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join("&")
      |> Wechat.Util.sha1()

    Map.put(params, :signature, signature)
  end
end
