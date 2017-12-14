defmodule Wechat.Plugs.MessageParser do
  @moduledoc false

  defmodule ParseError do
    defexception [:message]
  end

  import Plug.Conn
  import SweetXml

  import Wechat.Config, only: [token: 0, appid: 0, encoding_aes_key: 0]
  alias Wechat.Utils.MessageEncryptor
  alias Wechat.Utils.SignatureVerifier

  def init(opts) do
    opts
  end

  def call(%{method: "POST"} = conn, opts) do
    conn
    |> read_body(opts)
    |> decode
  end
  def call(conn, _opts) do
    conn
  end

  defp decode({:ok, body, conn}) do
    msg = extract_xml(body)
    if msg_encrypted?(conn.params) do
      case verify_msg_signature(msg, conn.query_params) do
        {:ok, msg_encrypted} ->
          msg_decrypted = decrypt(msg_encrypted)
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

  defp verify_msg_signature(%{"Encrypt" => msg_encrypted},
    %{"timestamp" => timestamp, "nonce" => nonce,
      "msg_signature" => signature}) do
    args = [token(), timestamp, nonce, msg_encrypted]
    if SignatureVerifier.verify?(args, signature) do
      {:ok, msg_encrypted}
    else
      :error
    end
  end

  defp decrypt(msg_encrypted) do
    appid = appid()
    encoding_aes_key = encoding_aes_key()
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
    |> Enum.into(%{}, &({xpath(&1, ~x"name(.)"s), xpath(&1, ~x"text()"s)}))
  end
end
