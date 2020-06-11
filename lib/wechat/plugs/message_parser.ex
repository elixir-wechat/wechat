defmodule Wechat.Plugs.MessageParser do
  @moduledoc """
  A plug to parse the message pushed by WeChat server.
  """

  defmodule ParseError do
    defexception [:message]
  end

  import Plug.Conn, only: [read_body: 1, send_resp: 3, halt: 1]

  alias Wechat.Utils.{MessageEncryptor, SignatureVerifier, XMLParser}

  @doc """
  Plug init callback.

  ## Example
      plug Wechat.Plugs.MessageParser, [module: MyApp.Wechat]
  """
  def init(opts) do
    module = Keyword.fetch!(opts, :module)
    %{module: module}
  end

  def call(%{method: "POST"} = conn, %{module: module}) do
    config = apply(module, :config, [])

    conn
    |> read_body()
    |> decode(config)
  end

  def call(conn, _opts) do
    conn
  end

  defp decode({:ok, body, conn}, config) do
    msg = XMLParser.parse(body)

    if msg_encrypted?(conn.params) do
      case verify_msg_signature(conn, msg, config) do
        {:ok, msg_encrypted} ->
          msg_decrypted = decrypt(msg_encrypted, config)
          %{conn | body_params: msg_decrypted}

        {:error, signature} ->
          raise ParseError, "Invalid msg_signature: #{signature}"
      end
    else
      %{conn | body_params: msg}
    end
  rescue
    _ ->
      conn
      |> send_resp(400, "Bad Request")
      |> halt()
  end

  defp verify_msg_signature(conn, msg, config) do
    token = Keyword.fetch!(config, :token)

    %{"timestamp" => timestamp, "nonce" => nonce, "msg_signature" => signature} =
      conn.query_params

    %{Encrypt: msg_encrypted} = msg

    args = [token, timestamp, nonce, msg_encrypted]

    if SignatureVerifier.verify?(args, signature) do
      {:ok, msg_encrypted}
    else
      {:error, signature}
    end
  end

  defp decrypt(msg_encrypted, config) do
    appid = Keyword.fetch!(config, :appid)
    encoding_aes_key = Keyword.fetch!(config, :encoding_aes_key)

    case MessageEncryptor.decrypt(msg_encrypted, encoding_aes_key) do
      {^appid, msg_decrypted} ->
        XMLParser.parse(msg_decrypted)

      _ ->
        raise ParseError, "Invalid appid: #{appid}"
    end
  end

  defp msg_encrypted?(%{"encrypt_type" => "aes"}), do: true
  defp msg_encrypted?(_), do: false
end
