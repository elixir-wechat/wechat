defmodule Wechat.Utils.SignatureVerifier do
  @moduledoc """
  Verify wechat signature.
  """

  def verify(args, signature) do
    challenge = args |> Enum.sort |> Enum.join |> sha1
    case Plug.Crypto.secure_compare(challenge, signature) do
      true -> :ok
      false -> :error
    end
  end

  defp sha1(str) do
    digest = :crypto.hash(:sha, str)
    Base.encode16(digest, case: :lower)
  end
end
