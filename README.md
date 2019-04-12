# Wechat
Wechat API wrapper in Elixir.

[![CircleCI](https://circleci.com/gh/elixir-wechat/wechat.svg?style=svg)](https://circleci.com/gh/elixir-wechat/wechat)

## Installation
```elixir
def deps do
  [{:wechat, "~> 0.4.0"}]
end
```

Warning: 0.4.0 is a rewrite for APIs, don't upgrade if you are using 0.3.0.

## Usage
```elixir
iex(1)> client = Wechat.Client.new(%{appid: "WECHAT_APPID", secret: "WECHAT_SECRET"})
%Wechat.Client{
  appid: "WECHAT_APPID",
  secret: "WECHAT_SECRET",
  endpoint: "https://api.weixin.qq.com/"
}
iex(2)> Wechat.User.get(client)
{:ok,
 %{
   "count" => 1,
   "data" => %{"openid" => ["oi00OuKAhA8bm5okpaIDs7WmUZr4"]},
   "next_openid" => "oi00OuKAhA8bm5okpaIDs7WmUZr4",
   "total" => 1
 }}
```

## Usage for plugs (in Phonenix controller)

* config.exs

  ```elixir
  config :my_app, MyApp.Wechat,
    appid: "APP_ID",
    secret: "APP_SECRET",
    token: "TOKEN",
    encoding_aes_key: "ENCODING_AES_KEY" # Required if you enabled the encrypt mode
  ```

* my_app/wechat.ex

  ```elixir
  defmodule MyApp.Wechat do
    use Wechat, otp_app: :beaver

    def users do
      client() |> Wechat.User.get()
    end
  end
  ```

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

      plug Wechat.Plugs.RequestValidator, module: MyApp.Wechat
      plug Wechat.Plugs.MessageParser, [module: MyApp.Wechat] when action in [:create]

      def index(conn, %{"echostr" => echostr}) do
        text conn, echostr
      end

      def create(conn, _params) do
        msg = conn.body_params
        reply = echo_reply(msg, msg.content)
        render conn, "text.xml", reply: reply
      end

      defp echo_reply(%{"ToUserName" => to, "FromUserName" => from}, content) do
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
