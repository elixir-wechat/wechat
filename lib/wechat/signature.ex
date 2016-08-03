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
    :crypto.hash(:sha, str)
    |> Base.encode16(case: :lower)
  end
end
