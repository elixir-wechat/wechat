defmodule Wechat.Message do
  @moduledoc false

  import Wechat

  @custom_message_types [
    :text,
    :image,
    :voice,
    :music,
    :news,
    :mpnews,
    :msgmenu,
    :wxcard,
    :miniprogrampage
  ]

  def custom_send(client, openid, type, content)
      when type in @custom_message_types and is_map(content) do
    body = %{touser: openid, msgtype: type, "#{type}": content}
    post(client, "cgi-bin/message/custom/send", body)
  end

  def custom_send_text(client, openid, content) do
    custom_send(client, openid, :text, %{content: content})
  end

  def custom_send_image(client, openid, media_id) do
    custom_send(client, openid, :image, %{media_id: media_id})
  end

  def custom_send_voice(client, openid, media_id) do
    custom_send(client, openid, :voice, %{media_id: media_id})
  end

  @doc """
  发送视频消息

  `opts`:
  title: 标题
  description: 描述
  """
  def custom_send_video(client, openid, media_id, thumb_media_id, opts \\ []) do
    content = Enum.into(opts, %{media_id: media_id, thumb_media_id: thumb_media_id})
    custom_send(client, openid, :video, content)
  end

  @doc """
  发送音乐消息

  `opts`:
  title: 标题
  description: 描述
  """
  def custom_send_music(client, openid, musicurl, hqmusicurl, thumb_media_id, opts \\ []) do
    content =
      Enum.into(opts, %{
        musicurl: musicurl,
        hqmusicurl: hqmusicurl,
        thumb_media_id: thumb_media_id
      })

    custom_send(client, openid, :music, content)
  end

  @doc """
  发送图文消息（点击跳转到外链） 图文消息条数限制在1条以内，注意，如果图文数超过1，则将会返回错误码45008。

  articles: [%{title: "", description: "", url: "", picurl: ""}]
  """
  def custom_send_news(client, openid, article) when is_map(article) do
    custom_send(client, openid, :news, %{articles: [article]})
  end

  @doc """
  发送图文消息（点击跳转到图文消息页面） 图文消息条数限制在1条以内，注意，如果图文数超过1，则将会返回错误码45008。
  """
  def custom_send_mpnews(client, openid, media_id) do
    custom_send(client, openid, :mpnews, %{media_id: media_id})
  end

  @doc """
  发送菜单消息

  `content`: %{head_content: "", list: [%{id: "", content: ""}], tail_content: ""}
  """
  def custom_send_msgmenu(client, openid, content) do
    custom_send(client, openid, :msgmenu, content)
  end

  @doc """
  发送卡券
  """
  def custom_send_wxcard(client, openid, card_id) do
    custom_send(client, openid, :wxcard, %{card_id: card_id})
  end

  @doc """
  发送迷你小程序

  `content`: %{
    title: "title",
    appid: "appid",
    pagepath: "pagepath",
    thumb_media_id: "thumb_media_id"
  }
  """
  def custom_send_miniprogrampage(client, openid, appid, pagepath, thumb_media_id, title \\ "") do
    content = %{appid: appid, pagepath: pagepath, thumb_media_id: thumb_media_id, title: title}
    custom_send(client, openid, :miniprogrampage, content)
  end

  def custom_typing_start(client, openid) do
    post(client, "cgi-bin/message/custom/typing", %{touser: openid, command: "Typing"})
  end

  def custom_typing_cancel(client, openid) do
    post(client, "cgi-bin/message/custom/typing", %{touser: openid, command: "CancelTyping"})
  end

  @doc """
  `data`: %{ // 模版数据
    key: %{ // 模版中的key
      value: // 对应的value
      color: // 模板内容字体颜色，不填默认为黑色
    }
  }

  `opts`:
  url: 模板跳转链接（海外帐号没有跳转能力）
  miniprogram: %{ // 跳小程序所需数据，不需跳小程序可不用传该数据
    appid: "xiaochengxuappid12345" // 所需跳转到的小程序appid,
    pagepath: "index?foo=bar" // 所需跳转到小程序的具体页面路径，支持带参数
  }
  """
  def template_send(client, openid, template_id, data, opts \\ []) when is_map(data) do
    body = Enum.into(opts, %{touser: openid, template_id: template_id, data: data})
    post(client, "cgi-bin/message/template/send", body)
  end
end
