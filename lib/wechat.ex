defmodule Wechat do
  @moduledoc false

  alias Wechat.Workers.AccessToken
  alias Wechat.Workers.JSAPITicket

  defdelegate access_token, to: AccessToken, as: :get
  defdelegate jsapi_ticket, to: JSAPITicket, as: :get
end
