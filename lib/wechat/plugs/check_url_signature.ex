defmodule Wechat.Plugs.CheckUrlSignature do
  @moduledoc """
  Plug to check url signature.
  """

  import Plug.Conn
  import Wechat.Utils.Signature

  def init(opts) do
    Keyword.merge opts,
      token: Wechat.token
  end

  def call(conn = %Plug.Conn{params: params}, [token: token]) do
    %{"timestamp" => timestamp, "nonce" => nonce,
      "signature" => signature} = params
    my_signature = [token, timestamp, nonce] |> sign
    case my_signature == signature do
      true ->
        conn
      false ->
        conn
        |> send_resp(400, "")
        |> halt
    end
  end
end
