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
    decoder = Keyword.get(opts, :wechat_decoder) ||
      raise ArgumentError, "WECHAT parser expects a :wechat_decoder option"
    conn
    |> read_body(opts)
    |> decode(decoder)
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end

  defp decode({:more, _, conn}, _decoder) do
    {:error, :too_large, conn}
  end

  defp decode({:error, :timeout}, _decoder) do
    raise Plug.TimeoutError
  end

  defp decode({:error, _}, _decoder) do
    raise Plug.BadRequestError
  end

  defp decode({:ok, body, conn}, decoder) do
    msg = extract_xml(body)
    case msg_encrypted?(conn.params) do
      true -> decrypt_msg(conn, msg, decoder)
      false -> {:ok, msg, conn}
    end
  rescue
    e -> raise Plug.Parsers.ParseError, exception: e
  end

  defp decrypt_msg(conn, %{"Encrypt" => msg_encrypted}, decoder) do
    appid = decoder.appid
    token = decoder.token
    encoding_aes_key = decoder.encoding_aes_key

    %{"timestamp" => timestamp, "nonce" => nonce, "msg_signature" => signature} = conn.params
    case SignatureVerifier.verify([token, timestamp, nonce, msg_encrypted], signature) do
      true ->
        case MessageEncryptor.decrypt(msg_encrypted, encoding_aes_key) do
          {^appid, msg_decrypted} ->
            {:ok, extract_xml(msg_decrypted), conn}
          _ ->
            raise ParseError, "invalid appid"
        end
      false ->
        raise ParseError, "invalid msg_signature"
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
