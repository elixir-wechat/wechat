defmodule Wechat.Worker.AccessTokenTest do
  use ExUnit.Case, async: false

  alias Wechat.Workers.AccessToken
  
  test "custom fetcher" do
    Application.put_env(
      :wechat,
      Wechat,
      [access_token_fetcher: {__MODULE__, :fetch_token, []}]
    )

    AccessToken.start_link([])
    Process.send AccessToken, :refresh, []

    assert GenServer.call(AccessToken, :get) == "test" 
  end

  test "setting custom refresh token" do
    interval = :timer.minutes(10)

    Application.put_env(
      :wechat,
      Wechat,
      [access_token_refresh_interval: interval]
    )

    assert AccessToken.refresh_interval == interval
  end

  def fetch_token do
    %{"access_token" => "test"}
  end

end

