defmodule Wechat.Adapter do
  @moduledoc """
  Adapter interface.
  """

  alias Wechat.AccessToken

  @type appid :: binary

  @callback read_token(appid) :: {:ok, AccessToken.t()} | :error
  @callback write_token(appid, AccessToken.t()) :: :ok
end
