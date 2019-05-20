defmodule Wechat.Util do
  @moduledoc false

  def unix_now, do: DateTime.utc_now() |> DateTime.to_unix()

  def sha1(str) do
    digest = :crypto.hash(:sha, str)
    Base.encode16(digest, case: :lower)
  end
end
