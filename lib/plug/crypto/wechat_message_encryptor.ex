defmodule Plug.Crypto.WechatMessageEncryptor do
  @moduledoc """
  Encrypt and decrypt wechat messages.
  """

  def decrypt(encrypted, aes_key) do
    plain_text =
      encrypted
      |> Base.decode64!
      |> decrypt_aes(aes_key)
      |> decode_padding

    # random(16B) + msg_len(4B) + msg + appid
    <<_ :: binary-size(16),
      msg_len :: integer-size(32),
      msg :: binary-size(msg_len),
      appid :: binary>> = plain_text

    {appid, msg}
  end

  defp decrypt_aes(aes_encrypt, aes_key) do
    iv = binary_part(aes_key, 0, 16)
    :crypto.block_decrypt(:aes_cbc, aes_key, iv, aes_encrypt)
  end

  defp decode_padding(padded_text) do
    len = byte_size(padded_text)
    <<pad :: utf8>> = binary_part(padded_text, len, -1)
    case pad < 1 or pad > 32 do
      true -> binary_part(padded_text, 0, len)
      false -> binary_part(padded_text, 0, len - pad)
    end
  end
end
