defmodule Plug.Parsers.WECHAT do
  @moduledoc """
  Parses wechat pushed messages.
  """

  @behaviour Plug.Parsers

  defmodule ParseError do
    defexception [:message]
  end

  import Plug.Conn
  import SweetXml

  alias Plug.Crypto.WechatMessageEncryptor, as: MessageEncryptor
  alias Plug.Crypto.WechatSignatureVerifier, as: SignatureVerifier

  def parse(conn, "text", "xml", _headers, opts) do
    config = Keyword.get(opts, :wechat_config) ||
      raise ArgumentError, "WECHAT parser expects a :wechat_config option"
    conn
    |> read_body(opts)
    |> decode(config)
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end

  defp decode({:more, _, conn}, _config) do
    {:error, :too_large, conn}
  end

  defp decode({:error, :timeout}, _config) do
    raise Plug.TimeoutError
  end

  defp decode({:error, _}, _config) do
    raise Plug.BadRequestError
  end

  defp decode({:ok, body, conn}, config) do
    msg = extract_xml(body)
    case msg_encrypted?(conn.params) do
      true ->
        case verify_msg_signature(config.token, msg, conn.query_params) do
          {:ok, msg_encrypted} -> {:ok, decrypt(msg_encrypted, config), conn}
          :error -> raise ParseError, "invalid msg_signature"
        end
      false ->
        {:ok, msg, conn}
    end
  rescue
    e -> raise Plug.Parsers.ParseError, exception: e
  end

  defp verify_msg_signature(token, %{"Encrypt" => msg_encrypted},
    %{"timestamp" => timestamp, "nonce" => nonce,
      "msg_signature" => signature}) do
    args = [token, timestamp, nonce, msg_encrypted]
    case SignatureVerifier.verify(args, signature) do
      :ok ->
        {:ok, msg_encrypted}
      :error ->
        :error
    end
  end

  defp decrypt(msg_encrypted, config) do
    appid = config.appid
    encoding_aes_key = config.encoding_aes_key
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
