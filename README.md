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
