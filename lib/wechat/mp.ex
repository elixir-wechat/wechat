defmodule Wechat.MP do
  @moduledoc false

  alias Wechat.Config

  use Wechat.HTTP, host: Config.config[:mp_host]

  def show_qrcode(ticket) do
    get "/showqrcode", %{
      ticket: ticket
    }
  end
end
