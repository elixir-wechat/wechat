defmodule Wechat.Plugs.MessageParser do
  @moduledoc false

  defmodule ParseError do
    defexception [:message]
  end

  import Plug.Conn
  import SweetXml

  alias Wechat.Utils.{MessageEncryptor, SignatureVerifier}

  def init(opts) do
    module = Keyword.fetch!(opts, :module)
    config = apply(module, :config, [])

    appid = Keyword.fetch!(config, :appid)
    token = Keyword.fetch!(config, :token)
    encoding_aes_key = Keyword.get(config, :encoding_aes_key)
    %{appid: appid, token: token, encoding_aes_key: encoding_aes_key}
  end

  def call(%{method: "POST"} = conn, config) do
    conn
    |> read_body()
    |> decode(config)
  end

  def call(conn, _opts) do
    conn
  end

  defp decode({:ok, body, conn}, config) do
    msg = extract_xml(body)

    if msg_encrypted?(conn.params) do
      case verify_msg_signature(conn, msg, config) do
        {:ok, msg_encrypted} ->
          msg_decrypted = decrypt(msg_encrypted, config)
          %{conn | body_params: msg_decrypted}

        :error ->
          raise ParseError, "invalid msg_signature"
      end
    else
      %{conn | body_params: msg}
    end
  rescue
    _ ->
      conn
      |> send_resp(400, "")
      |> halt
  end

  defp verify_msg_signature(conn, msg, %{token: token}) do
    %{"timestamp" => timestamp, "nonce" => nonce, "msg_signature" => signature} =
      conn.query_params

    %{"Encrypt" => msg_encrypted} = msg

    args = [token, timestamp, nonce, msg_encrypted]

    if SignatureVerifier.verify?(args, signature) do
      {:ok, msg_encrypted}
    else
      :error
    end
  end

  defp decrypt(msg_encrypted, %{appid: appid, encoding_aes_key: encoding_aes_key}) do
    case MessageEncryptor.decrypt(msg_encrypted, encoding_aes_key) do
      {^appid, msg_decrypted} ->
        extract_xml(msg_decrypted)

      _ ->
        raise ParseError, "invalid appid"
    end
  end

  defp msg_encrypted?(%{"encrypt_type" => "aes"}), do: true
  defp msg_encrypted?(_), do: false

  def extract_xml(doc) do
    doc
    |> xpath(~x"//xml/*"l)
    |> Enum.into(%{}, &{xpath(&1, ~x"name(.)"s), xpath(&1, ~x"text()"s)})
  end
end
