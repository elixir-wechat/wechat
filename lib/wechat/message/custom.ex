defmodule Wechat.Message.Custom do
  @moduledoc """
  Custom Message API.

  Ref: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140547
  """
  alias Wechat.API

  @api_path "/message/custom/send"
  @types ~w(text image voice video music news mpnews wxcard link miniprogrampage)

  def send_text(openid, content) do
    "text"
    |> build_message(%{"content" => content})
    |> deliver(openid)
  end

  def send_image(openid, media_id) do
    "image"
    |> build_message(%{"media_id" => media_id})
    |> deliver(openid)
  end

  def send_voice(openid, media_id) do
    "voice"
    |> build_message(%{"media_id" => media_id})
    |> deliver(openid)
  end

  def send_video(openid, media_id, thumb_media_id, opts \\ []) do
    content = %{
      "title" => opts[:title],
      "description" => opts[:description],
      "media_id" => media_id,
      "thumb_media_id" => thumb_media_id
    }

    "video"
    |> build_message(content)
    |> deliver(openid)
  end

  def send_music(openid, musicurl, hqmusicurl, thumb_media_id, opts \\ []) do
    content = %{
      "title" => opts[:title],
      "description" => opts[:description],
      "musicurl" => musicurl,
      "hqmusicurl" => hqmusicurl,
      "thumb_media_id" => thumb_media_id
    }

    "music"
    |> build_message(content)
    |> deliver(openid)
  end

  @news_max_articles 8
  def send_news(openid, articles) when length(articles) <= @news_max_articles do
    "news"
    |> build_message(%{"articles" => articles})
    |> deliver(openid)
  end

  def send_mpnews(openid, media_id) do
    "mpnews"
    |> build_message(%{"media_id" => media_id})
    |> deliver(openid)
  end

  def send_wxcard(openid, card_id, card_ext) do
    "wxcard"
    |> build_message(%{"card_id" => card_id, "card_ext" => card_ext})
    |> deliver(openid)
  end

  # See https://mp.weixin.qq.com/debug/wxadoc/dev/api/custommsg/conversation.html
  def send_link(openid, content) do
    "link"
    |> build_message(content)
    |> deliver(openid)
  end

  def send_mini_program_page(openid, content) do
    "miniprogrampage"
    |> build_message(content)
    |> deliver(openid)
  end

  defp build_message(type, content) when type in @types do
    %{"msgtype" => type, type => content}
  end

  defp deliver(body, openid) when is_map body do
    body = Map.merge(body, %{"touser" => openid})
    API.post @api_path, body
  end
end
