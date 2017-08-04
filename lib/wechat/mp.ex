defmodule Wechat.MP do
  @moduledoc false

  use Wechat.HTTP, host: Wechat.config[:mp_host]

  def show_qrcode(ticket) do
    get "/showqrcode", %{
      ticket: ticket
    }
  end
end
