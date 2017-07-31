defmodule Wechat.Signature do
  @moduledoc """
  Generate signature.
  """

  def sign(args) do
    args
    |> Enum.sort
    |> Enum.join
    |> sha1
  end

  defp sha1(str) do
    digest = :crypto.hash(:sha, str)
    Base.encode16(digest, case: :lower)
  end
end
