defmodule Plug.Crypto.WechatSignatureVerifier do
  @moduledoc """
  Verify wechat signature.
  """

  def verify(args, signature) do
    challenge = args |> Enum.sort |> Enum.join |> sha1
    Plug.Crypto.secure_compare(challenge, signature)
  end

  defp sha1(str) do
    digest = :crypto.hash(:sha, str)
    Base.encode16(digest, case: :lower)
  end
end
