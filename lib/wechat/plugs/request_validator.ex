defmodule Wechat.Plugs.RequestValidator do
  @moduledoc false

  import Plug.Conn

  alias Wechat.Utils.SignatureVerifier

  def init(opts) do
    module = Keyword.fetch!(opts, :module)
    config = apply(module, :config, [])

    token = Keyword.fetch!(config, :token)
    %{token: token}
  end

  def call(conn, %{token: token}) do
    conn = fetch_query_params(conn)
    %{"timestamp" => timestamp, "nonce" => nonce, "signature" => signature} = conn.query_params

    if SignatureVerifier.verify?([token, timestamp, nonce], signature) do
      conn
    else
      conn |> send_resp(400, "") |> halt
    end
  end
end
