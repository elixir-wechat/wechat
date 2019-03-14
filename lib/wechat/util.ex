defmodule Wechat.Util do
  @moduledoc false

  def unix_now, do: DateTime.utc_now() |> DateTime.to_unix()
end
