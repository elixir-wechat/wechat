defmodule Wechat.Utils.MessageEncryptor do
  @moduledoc """
  Encrypt and decrypt Wechat messages.
  """

  @aes_key_size_in_bytes 32
  @aes_block_size_in_bytes 16

  # get AES key from encoding_aes_key.
  defp aes_key(encoding_aes_key) do
    Base.decode64!(encoding_aes_key <> "=")
  end

  @doc """
  Encrypt plain text by AES-CBC padded by PKCS#7.
  """
  def encrypt(msg, encoding_aes_key, appid) do
    msg
    |> pack_appid(appid)
    |> encode_padding_with_pkcs7
    |> encrypt_with_aes_cbc(aes_key(encoding_aes_key))
    |> Base.encode64
  end

  # random(16B) + msg_len(4B) + msg + appid
  defp pack_appid(msg, appid) do
    random = SecureRandom.random_bytes(16)
    msg_len = String.length(msg)
    random <> <<msg_len :: 32>> <> msg <> appid
  end

  defp encode_padding_with_pkcs7(data) do
    data_size = byte_size(data)
    size_to_pad = @aes_key_size_in_bytes - rem(data_size, @aes_key_size_in_bytes)
    data <> String.duplicate(<<size_to_pad :: 8>>, size_to_pad)
  end

  defp encrypt_with_aes_cbc(plain_text, aes_key) do
    iv = binary_part(aes_key, 0, @aes_block_size_in_bytes)
    :crypto.block_encrypt(:aes_cbc, aes_key, iv, plain_text)
  end

  @doc """
  Decrypt cipher text with AES-CBC padded by PKCS#7.
  """
  def decrypt(msg_encrypted, encoding_aes_key) do
    msg_encrypted
    |> Base.decode64!
    |> decrypt_with_aes_cbc(aes_key(encoding_aes_key))
    |> decode_padding_with_pkcs7
    |> unpack_appid
  end

  defp decrypt_with_aes_cbc(cipher_text, aes_key) do
    iv = binary_part(aes_key, 0, @aes_block_size_in_bytes)
    :crypto.block_decrypt(:aes_cbc, aes_key, iv, cipher_text)
  end

  defp decode_padding_with_pkcs7(data) do
    data_size = byte_size(data)
    <<pad :: 8>> = binary_part(data, data_size, -1)
    binary_part(data, 0, data_size - pad)
  end

  # random(16B) + msg_len(4B) + msg + appid
  defp unpack_appid(<<_ :: binary-16, msg_len :: integer-32,
    msg :: binary-size(msg_len), appid :: binary>>) do
    {appid, msg}
  end
end
