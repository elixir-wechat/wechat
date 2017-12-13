# Wechat

Wechat API wrapper in Elixir.

[![Build Status](https://travis-ci.org/goofansu/wechat-elixir.svg?branch=master)](https://travis-ci.org/goofansu/wechat-elixir)
[![codebeat badge](https://codebeat.co/badges/60f20da5-c961-4100-a19e-135ad79c8457)](https://codebeat.co/projects/github-com-goofansu-wechat-elixir-master)
[![Coverage Status](https://coveralls.io/repos/github/goofansu/wechat-elixir/badge.svg)](https://coveralls.io/github/goofansu/wechat-elixir)

## Installation

### stable

  ```elixir
  def deps do
    [{:wechat, "~> 0.3.0"}]
  end
  ```

### development

  ```elixir
  def deps do
    [{:wechat, github: "goofansu/wechat-elixir"}]
  end
  ```

## Config

* Add config in `config.exs`

    ```elixir
    config :wechat, Wechat,
      appid: "wechat app id",
      secret: "wechat app secret",
      token: "wechat token",
      encoding_aes_key: "32bits key" # 只有"兼容模式"和"安全模式"才需要配置这个值
    ```

## Usage

* access_token

    ```elixir
    iex> Wechat.access_token
    "Bgw6_cMvFrE3hY3J8U6oglhvlzHhMpAQma0Wjam4XsLx8F6XP4pfZzsezBdpfth2BNAdUK6wA23S7D3fSePt7meG9a1gf9LhEmXjxGelnTjJLaIQMYumrCHE_9gcFVXaHIHcAGACDC"
    ```

* user

    ```elixir
    iex> Wechat.User.get
    %{count: 4,
    data: %{openid: ["oi00OuFrmNEC-QMa0Kikycq6A7ys",
     "oi00OuKAhA8bm5okpaIDs7WmUZr4", "oi00OuOdjK0TicVUmovudbSP5Zq4",
     "oi00OuBgG2mko_pOukCy00EYCwo4"]},
    next_openid: "oi00OuBgG2mko_pOukCy00EYCwo4", total: 4}

    iex> Wechat.User.info("oi00OuKAhA8bm5okpaIDs7WmUZr4")
    %{city: "宝山", country: "中国", groupid: 0,
    headimgurl: "http://wx.qlogo.cn/mmopen/7raJSSs9gLVJibia6sAXRvr8jajXfQFWiagrLwrRIZjMHCEXOxYf6nflxcpl4WkT7gz8Sa4tO32avnI0dlNLn24yA/0",
    language: "zh_CN", nickname: "小爆炸的爸爸",
    openid: "oi00OuKAhA8bm5okpaIDs7WmUZr4", province: "上海", remark: "",
    sex: 1, subscribe: 1, subscribe_time: 1449812483, tagid_list: [],
    unionid: "o2oUsuOUzgNL-JSLtIp8b3FzkI-M"}
    ```

* media

    ```elixir
    iex> file = Wechat.Media.download("GuSq91L0FXQFOIFtKwX2i5UPXH9QKnnu63_z4JHZwIw3TMIn1C-xm8hX3nPWCA")
   iex> File.write!('/tmp/file', file)
    ```

## Plug

* `Wechat.Plugs.CheckUrlSignature`

  * Check url signature
  * [接入指南](http://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421135319&token=&lang=zh_CN)

* `Wechat.Plugs.CheckMsgSignature`

  * Parse xml message (support decrypt msg)
  * [消息加密解密技术方案](http://mp.weixin.qq.com/wiki/2/3478f69c0d0bbe8deb48d66a3111ff6e.html)

## Plug Usage (in Phonenix controller)

* router.ex

    ```elixir
    defmodule MyApp.Router do
      pipeline :api do
        plug :accepts, ["json"]
      end

      scope "/wechat", MyApp do
        pipe_through :api

        # validate wechat server config
        get "/", WechatController, :index

        # receive wechat push message
        post "/", WechatController, :create
      end
    end
    ```

* wechat_controller.ex

    ```elixir
    defmodule MyApp.WechatController do
      use MyApp.Web, :controller

      plug Wechat.Plugs.ValidateRequest
      plug Wechat.Plugs.ParseMessage when action in [:create]

      def index(conn, %{"echostr" => echostr}) do
        text conn, echostr
      end

      def create(conn, _params) do
        msg = conn.body_params
        reply = build_text_reply(msg, msg.content)
        render conn, "text.xml", reply: reply
      end

      defp build_text_reply(%{"ToUserName" => to, "FromUserName" => from}, content) do
        %{from: to, to: from, content: content}
      end
    end
    ```

* text.xml.eex

    ```xml
    <xml>
      <MsgType><![CDATA[text]]></MsgType>
      <Content><![CDATA[<%= @reply.content %>]]></Content>
      <ToUserName><![CDATA[<%= @reply.to %>]]></ToUserName>
      <FromUserName><![CDATA[<%= @reply.from %>]]></FromUserName>
      <CreateTime><%= DateTime.to_unix(DateTime.utc_now) %></CreateTime>
    </xml>
    ```
