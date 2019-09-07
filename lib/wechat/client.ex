defmodule Wechat.Client do
  @moduledoc """
  `Client` represents an API client.
  """

  alias Wechat.{AccessToken, Config, Error}
  alias Wechat.Utils.{MessageEncryptor, SignatureVerifier}

  @endpoint "https://api.weixin.qq.com/"

  @enforce_keys [:appid, :secret]
  defstruct appid: nil,
            secret: nil,
            token: nil,
            encoding_aes_key: nil,
            endpoint: nil,
            access_token: nil

  @type t :: %__MODULE__{
          appid: binary | nil,
          secret: binary | nil,
          token: binary | nil,
          encoding_aes_key: binary | nil,
          endpoint: binary,
          access_token: binary | nil
        }

  @doc """
  Create client to consume Wechat API with config.

  ## Example

      iex> Wechat.Client.new(appid: "my_appid", secret: "my_secret")
      %Wechat.Client{
        appid: "my_appid",
        secret: "my_secret",
        endpoint: "https://api.weixin.qq.com/"
      }

      iex> Wechat.Client.new(appid: "my_appid", secret: "my_secret", endpoint: "http://localhost")
      %Wechat.Client{
        appid: "my_appid",
        secret: "my_secret",
        endpoint: "http://localhost/"
      }
  """
  @spec new(Keyword.t()) :: t
  def new(opts) do
    endpoint =
      opts
      |> Keyword.get(:endpoint, @endpoint)
      |> ensure_trailing_slash()

    opts = Keyword.put(opts, :endpoint, endpoint)
    struct!(__MODULE__, opts)
  end

  defp ensure_trailing_slash(endpoint) do
    if String.ends_with?(endpoint, "/") do
      endpoint
    else
      endpoint <> "/"
    end
  end

  @spec get_token(t) :: {:ok, t} | {:error, Error.t()}
  def get_token(client) do
    case Wechat.token(client) do
      {:ok, body} ->
        token = AccessToken.new(body)
        :ok = Config.adapter().write_token(client.appid, token)
        {:ok, %{client | access_token: token.access_token}}

      {:error, error} ->
        {:error, error}
    end
  end

  def get_token!(client) do
    case get_token(client) do
      {:ok, client} ->
        client

      {:error, error} ->
        raise error
    end
  end

  @spec access_token(t) :: binary
  def access_token(%{access_token: nil, appid: appid}) do
    case Config.adapter().read_token(appid) do
      {:ok, token} -> token.access_token
      :error -> ""
    end
  end

  def access_token(%{access_token: access_token}), do: access_token

  @doc """
  Sign jsapi with url.
  """
  @spec sign_jsapi(t, :binary) :: map
  def sign_jsapi(client, url) do
    {:ok, %{"ticket" => ticket}} = Wechat.Ticket.get_ticket(client, :jsapi)
    timestamp = Wechat.Util.unix_now()
    nonce = Wechat.Util.nonce()

    params = %{jsapi_ticket: ticket, noncestr: nonce, timestamp: timestamp, url: url}

    signature =
      params
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join("&")
      |> Wechat.Util.sha1()

    Map.put(params, :signature, signature)
  end

  @doc """
  Encrypt message with encoding_aes_key.
  """
  def encrypt_message(client, msg) do
    if client.encoding_aes_key do
      %{appid: appid, token: token, encoding_aes_key: encoding_aes_key} = client
      msg_encrypt = MessageEncryptor.encrypt(msg, appid, encoding_aes_key)
      timestamp = Wechat.Util.unix_now()
      nonce = Wechat.Util.nonce()

      msg_signature = SignatureVerifier.sign([token, timestamp, nonce, msg_encrypt])

      reply = %{
        msg_encrypt: msg_encrypt,
        msg_signature: msg_signature,
        timestamp: timestamp,
        nonce: nonce
      }

      {:ok, reply}
    else
      {:error, msg}
    end
  end

  @doc """
  Configure JS-SDK.
  """
  def wechat_config_js(client, url, opts) do
    debug = Keyword.get(opts, :debug, false)
    js_api_list = opts |> Keyword.get(:api, []) |> Enum.join(",")
    %{timestamp: timestamp, noncestr: nonce, signature: signature} = sign_jsapi(client, url)

    """
    <script type="text/javascript">
      wx.config({
        debug: #{debug},
        jsApiList: ['#{js_api_list}'],
        appId: '#{client.appid}',
        timestamp: '#{timestamp}',
        nonceStr: '#{nonce}',
        signature: '#{signature}'
      });
    </script>
    """
  end
end
