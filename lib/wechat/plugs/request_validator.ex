defmodule Wechat.Plugs.RequestValidator do
  @moduledoc """
  A plug to verify the `signature` param in WeChat pushed URL.
  """

  import Plug.Conn

  alias Wechat.Utils.SignatureVerifier

  @doc """
  Plug init callback.

  ## Example
      plug Wechat.Plugs.RequestValidator, module: MyApp.Wechat
  """
  def init(opts) do
    module = Keyword.fetch!(opts, :module)
    %{module: module}
  end

  def call(conn, module) do
    config = apply(module, :config, [])
    token = Keyword.fetch!(config, :token)

    conn = fetch_query_params(conn)
    %{"timestamp" => timestamp, "nonce" => nonce, "signature" => signature} = conn.query_params

    if SignatureVerifier.verify?([token, timestamp, nonce], signature) do
      conn
    else
      conn |> send_resp(400, "") |> halt
    end
  end
end
