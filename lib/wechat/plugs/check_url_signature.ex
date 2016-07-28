defmodule Wechat.Plugs.CheckUrlSignature do
  @moduledoc """
  Plug to check url signature.
  """

  import Plug.Conn

  def init(opts) do
    Keyword.merge(opts, token: Wechat.config[:token])
  end

  def call(conn = %Plug.Conn{params: params}, [token: token]) do
    %{"timestamp" => timestamp, "nonce" => nonce,
      "signature" => signature} = params
    my_signature = sign [token, timestamp, nonce]
    case my_signature == signature do
      true ->
        conn
      false ->
        conn
        |> send_resp(400, "")
        |> halt
    end
  end

  defp sign(args) do
    args
    |> Enum.sort
    |> Enum.join
    |> sha1
  end

  defp sha1(str) do
    :crypto.hash(:sha, str)
    |> Base.encode16(case: :lower)
  end
end
