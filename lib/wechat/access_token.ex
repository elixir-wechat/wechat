defmodule Wechat.AccessToken do
  @moduledoc false

  import Wechat.Util

  defstruct access_token: "", expires_at: nil

  @type t :: %__MODULE__{access_token: binary, expires_at: integer | nil}

  @spec new(binary) :: t
  def new(access_token) when is_binary(access_token) do
    new(%{"access_token" => access_token, "expires_in" => nil})
  end

  @spec new(%{binary => binary}) :: t
  def new(%{"access_token" => access_token, "expires_in" => expires_in}) do
    struct(__MODULE__, access_token: access_token, expires_at: expires_at(expires_in))
  end

  defp expires_at(nil), do: nil

  defp expires_at(expires_in) do
    unix_now() + expires_in
  end
end
