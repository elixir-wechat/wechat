defmodule Router do
  @moduledoc """
  Router to accept push events.
  """
  use Plug.Router
  alias Plug.Crypto.WechatSignatureVerifier, as: SignatureVerifier

  plug :match
  plug Plug.Parsers, parsers: [:wechat], wechat_config: Wechat.Config
  plug :dispatch

  get "/wechat" do
    %{"echostr" => echostr, "timestamp" => timestamp,
      "nonce" => nonce, "signature" => signature} = conn.query_params
    case SignatureVerifier.verify([Wechat.token, timestamp, nonce], signature) do
      true -> send_resp(conn, 200, echostr)
      false -> send_resp(conn, 200, "invalid signature")
    end
  end

  post "/wechat" do
    params = conn.body_params
    IO.inspect params
    send_resp(conn, 200, "success")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  def start(port \\ 4000) do
    Plug.Adapters.Cowboy.http Router, [], port: port
  end

  def stop do
    Plug.Adapters.Cowboy.shutdown Router.HTTP
  end

  use Plug.ErrorHandler
  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
