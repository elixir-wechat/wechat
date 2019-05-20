defmodule Wechat.Utils.SignatureVerifier do
  @moduledoc """
  Verify wechat signature.
  """

  alias Plug.Crypto, as: PCryto

  def verify?(args, signature) do
    args
    |> sign
    |> PCryto.secure_compare(signature)
  end

  def sign(args) do
    args
    |> Enum.sort()
    |> Enum.join()
    |> Wechat.Util.sha1()
  end
end
