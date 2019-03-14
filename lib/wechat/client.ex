defmodule Wechat.Client do
  @moduledoc """
  `Client` represents an API client.
  """

  alias Wechat.{AccessToken, Base, Config, Error}

  defstruct auth: nil, endpoint: "https://api.weixin.qq.com/"

  @type auth :: %{appid: binary, secret: binary} | %{access_token: binary}
  @type t :: %__MODULE__{auth: auth | nil, endpoint: binary}

  @doc ~S"""
  Create client to consume Wechat API with `auth`.

  ## Examples

      iex> Wechat.Client.new(%{appid: "my_appid", secret: "my_secret"})
      %Wechat.Client{
        auth: %{appid: "my_appid", secret: "my_secret"},
        endpoint: "https://api.weixin.qq.com/"
      }

      iex> Wechat.Client.new(%{appid: "my_appid", secret: "my_secret"}, "http://localhost")
      %Wechat.Client{
        auth: %{appid: "my_appid", secret: "my_secret"},
        endpoint: "http://localhost/"
      }
  """
  @spec new(auth) :: t
  def new(auth) do
    %__MODULE__{auth: auth}
  end

  @spec new(auth, binary) :: t
  def new(auth, endpoint) do
    endpoint = ensure_trailing_slash(endpoint)
    %__MODULE__{auth: auth, endpoint: endpoint}
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
        :ok = Config.adapter().write_token(client.auth.appid, token)
        {:ok, %{client | auth: %{access_token: token.access_token}}}

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

  @spec access_token(auth) :: binary
  def access_token(%{access_token: access_token}), do: access_token

  def access_token(%{appid: appid}) do
    case Config.adapter().read_token(appid) do
      {:ok, token} -> token.access_token
      :error -> ""
    end
  end
end
