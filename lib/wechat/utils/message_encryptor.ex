defmodule Wechat.Utils.MessageEncryptor do
  @moduledoc """
  Encrypt and decrypt Wechat messages.
  """

  @aes_block_size 16

  @doc """
  Encrypt plain text by AES-CBC padded by PKCS#7.
  """
  def encrypt(msg, appid, encoding_aes_key) do
    with aes_key <- aes_key(encoding_aes_key) do
      msg
      |> pack_appid(appid)
      |> encode_padding_with_pkcs7(32)
      |> encrypt_with_aes_cbc(aes_key)
      |> Base.encode64()
    end
  end

  @doc """
  Decrypt cipher text with AES-CBC padded by PKCS#7.
  """
  def decrypt(msg_encrypted, encoding_aes_key) do
    with aes_key <- aes_key(encoding_aes_key) do
      msg_encrypted
      |> Base.decode64!()
      |> decrypt_with_aes_cbc(aes_key)
      |> decode_padding_with_pkcs7()
      |> unpack_appid()
    end
  end

  # random(16B) + msg_size(4B) + msg + appid
  defp pack_appid(msg, appid) do
    random = :crypto.strong_rand_bytes(16)
    msg_size = byte_size(msg)
    random <> <<msg_size::32>> <> msg <> appid
  end

  # random(16B) + msg_size(4B) + msg + appid
  defp unpack_appid(<<_::binary-16, msg_size::32, msg::binary-size(msg_size), appid::binary>>) do
    {appid, msg}
  end

  defp encode_padding_with_pkcs7(data, pad_block_size) do
    pad = calc_pad(data, pad_block_size)
    padding = String.duplicate(<<pad::8>>, pad)
    data <> padding
  end

  defp decode_padding_with_pkcs7(data) do
    data_size = byte_size(data)
    <<pad::8>> = binary_part(data, data_size, -1)
    binary_part(data, 0, data_size - pad)
  end

  defp encrypt_with_aes_cbc(plain_text, aes_key) do
    iv = binary_part(aes_key, 0, @aes_block_size)
    :crypto.block_encrypt(:aes_cbc, aes_key, iv, plain_text)
  end

  defp decrypt_with_aes_cbc(cipher_text, aes_key) do
    iv = binary_part(aes_key, 0, @aes_block_size)
    :crypto.block_decrypt(:aes_cbc, aes_key, iv, cipher_text)
  end

  defp calc_pad(data, pad_block_size) do
    data_size = byte_size(data)

    case rem(data_size, pad_block_size) do
      0 -> pad_block_size
      rem -> pad_block_size - rem
    end
  end

  # get AES key from encoding_aes_key.
  defp aes_key(encoding_aes_key) do
    Base.decode64!(encoding_aes_key <> "=")
  end
end
