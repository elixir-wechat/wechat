defmodule Wechat.Client do
  @moduledoc """
  `Client` represents an API client.
  """

  alias Wechat.{AccessToken, Base, Config, Error}

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

  ## Examples

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
    case Base.token(client) do
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
  def access_token(%{access_token: access_token}), do: access_token

  def access_token(%{appid: appid}) do
    case Config.adapter().read_token(appid) do
      {:ok, token} -> token.access_token
      :error -> ""
    end
  end
end
