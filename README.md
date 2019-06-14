# Wechat
Wechat API wrapper in Elixir.

[![CircleCI](https://circleci.com/gh/elixir-wechat/wechat.svg?style=svg)](https://circleci.com/gh/elixir-wechat/wechat)
[![codebeat badge](https://codebeat.co/badges/64e7b266-e8f7-428c-8ab1-22a7bf64116a)](https://codebeat.co/projects/github-com-elixir-wechat-wechat-master)
[![Hex.pm](https://img.shields.io/hexpm/v/wechat.svg)](https://hex.pm/packages/wechat)
![Hex.pm](https://img.shields.io/hexpm/dt/wechat.svg)

## Installation
```elixir
def deps do
  [{:wechat, "~> 0.4.0"}]
end
```

## Usage

### Create an API client with the credential
```elixir
iex(1)> client = Wechat.Client.new(%{appid: "WECHAT_APPID", secret: "WECHAT_SECRET"})
%Wechat.Client{
  appid: "WECHAT_APPID",
  secret: "WECHAT_SECRET",
  endpoint: "https://api.weixin.qq.com/"
}
```

### Use the client to call APIs
```elixir
iex(2)> Wechat.User.get(client)
{:ok,
 %{
   "count" => 1,
   "data" => %{"openid" => ["oi00OuKAhA8bm5okpaIDs7WmUZr4"]},
   "next_openid" => "oi00OuKAhA8bm5okpaIDs7WmUZr4",
   "total" => 1
 }}
```

## Implementation

You can implement the `Wechat` module to simplify the usage.

1. Create an implementation by `use Wechat`

```elixir
defmodule MyApp.Wechat do
  use Wechat, otp_app: :my_app
  
  def users do
    client() |> Wechat.User.get()
  end
end
```

2. Config the credential

```elixir
config :my_app, MyApp.Wechat,
  appid: "APP_ID",
  secret: "APP_SECRET",
  token: "TOKEN",
  encoding_aes_key: "ENCODING_AES_KEY" # Required if you enabled the encrypt mode
```

### Examples

1. Use JSAPI

```elixir
<script type="text/javascript" src="//res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
<%= raw MyApp.Wechat.wechat_config_js(@conn, debug: false, api: ~w(previewImage closeWindow)) %>

<script>
$(function() {
  var urls = [];
  $('img').map(function(){
    url = window.location.origin + $(this).attr('src'),
    urls.push(url);
  });

  $('img').click(function(e) {
    wx.previewImage({
      current: window.location.origin + $(this).attr('src'),
      urls: urls
    });
  })
});
</script>
```

2. Parse and return message (in Phoenix application)

* router.ex
```elixir
defmodule MyApp.Router do
  scope "/wechat", MyApp do
    resources "/", WechatController, [:index, :create]
  end
end
```

* wechat_controller.ex
```elixir
defmodule MyApp.WechatController do
  use MyApp.Web, :controller

  # Validate signature param
  plug Wechat.Plugs.RequestValidator, module: MyApp.Wechat

  # Parse message
  plug Wechat.Plugs.MessageParser, [module: MyApp.Wechat] when action in [:create]

  def index(conn, %{"echostr" => echostr}) do
    text conn, echostr
  end

  def create(conn, _params) do
    %{"ToUserName" => to, "FromUserName" => from, "Content" => content} = conn.body_params
    reply = %{from: to, to: from, content: content}

    msg = Phoenix.View.render_to_string(EvercamWechatWeb.WechatView, "text.xml", reply: reply)

    # Return encrypted message if possible
    case Wechat.encrypt_message(msg) do
      {:ok, reply} ->
        render(conn, "encrypt.xml", reply: reply)

      {:error, _} ->
        text(conn, msg)
    end
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
  
* encrypt.xml.eex
```xml
<xml>
  <Encrypt><![CDATA[<%= @reply.msg_encrypt %>]]></Encrypt>
  <MsgSignature><![CDATA[<%= @reply.msg_signature %>]]></MsgSignature>
  <TimeStamp><%= @reply.timestamp %></TimeStamp>
  <Nonce><![CDATA[<%= @reply.nonce %>]]></Nonce>
</xml>
```

## Configuration (optional)

```elixir
config :wechat,
  adapter_opts: {Wechat.Adapters.Redis, ["redis://localhost:6379/0"]},
  httpoison_opts: [recv_timeout: 300_000]
```

## Users

* [evercam_wechat](https://github.com/evercam/evercam_wechat)
