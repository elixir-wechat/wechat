defmodule Wechat.Message.Custom do
  @modueldoc """
  Custom Message API.

  ref: http://mp.weixin.qq.com/wiki/11/c88c270ae8935291626538f9c64bd123.html#.E5.AE.A2.E6.9C.8D.E6.8E.A5.E5.8F.A3-.E5.8F.91.E6.B6.88.E6.81.AF
  """
  alias Wechat.API

  @api_path "message/custom/send"
  @types ~w(text image voice video music news mpnews wxcard)

  def send_text(openid, content) do
    message =
      "text"
      |> build_message(%{"content" => content})

    deliver(openid, message)
  end

  def send_image(openid, media_id) do
    message =
      "image"
      |> build_message(%{"media_id" => media_id})

    deliver(openid, message)
  end

  def send_voice(openid, media_id) do
    message =
      "voice"
      |> build_message(%{"media_id" => media_id})

    deliver(openid, message)
  end

  def send_video(openid, media_id, thumb_media_id, opts \\ []) do
    title = Keyword.get(opts, :title)
    description = Keyword.get(opts, :description)

    message =
      "video"
      |> build_message(%{
                       "media_id" => media_id,
                       "thumb_media_id" => thumb_media_id,
                       "title" => title,
                       "description" => description
                     })

    deliver(openid, message)
  end

  def send_music(openid, musicurl, hqmusicurl, thumb_media_id, opts \\ []) do
    title = Keyword.get(opts, :title)
    description = Keyword.get(opts, :description)

    message =
      "music"
      |> build_message(%{
                       "title" => title,
                       "description" => description,
                       "musicurl" => musicurl,
                       "hqmusicurl" => hqmusicurl,
                       "thumb_media_id" => thumb_media_id
                     })

    deliver(openid, message)
  end

  @news_max_articles 8
  def send_news(openid, articles) when length(articles) <= @news_max_articles do
    message =
      "news"
      |> build_message(%{"articles" => articles})

    deliver(openid, message)
  end

  def send_mpnews(openid, media_id) do
    message =
      "mpnews"
      |> build_message(%{"media_id" => media_id})

    deliver(openid, message)
  end

  def send_wxcard(openid, card_id, card_ext) do
    message =
      "wxcard"
      |> build_message(%{
                       "card_id" => card_id,
                       "card_ext" => card_ext
                     })

    deliver(openid, message)
  end

  defp build_message(type, content) when type in @types do
    %{
      "msgtype" => type,
      type => content
    }
  end

  defp deliver(openid, body) when is_map body do
    body =
      body
      |> Map.merge(%{"touser" => openid})

    API.post @api_path, body
  end
end
