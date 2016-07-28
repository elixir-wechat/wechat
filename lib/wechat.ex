defmodule Wechat do
  @moduledoc false

  def config do
    default_config
    |> Keyword.merge(Application.get_env(:wechat, Wechat, []))
  end

  defp default_config do
    [token_file: "/tmp/access_token"]
  end

  def access_token do
    token_info = read_token_from_file
    token_info =
      case access_token_expired?(token_info) do
        true -> refresh_access_token
        false -> token_info
      end
    token_info.access_token
  end

  defp read_token_from_file do
    case File.read(config[:token_file]) do
      {:ok, binary} -> Poison.decode!(binary, keys: :atoms)
      {:error, _reason} -> refresh_access_token
    end
  end

  defp refresh_access_token do
    now = DateTime.to_unix(DateTime.utc_now)
    token_info = Map.merge(Wechat.AccessToken.token, %{refreshed_at: now})
    File.write(config[:token_file], Poison.encode!(token_info))
    token_info
  end

  defp access_token_expired?(token_info) do
    now = DateTime.utc_now |> DateTime.to_unix
    now >= (token_info.refreshed_at + token_info.expires_in)
  end
end
