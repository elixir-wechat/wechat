defmodule Wechat.APITest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.API

  test "retrieve access token" do
    use_cassette "access_token" do
      result = API.access_token
      assert Map.has_key?(result, "access_token")
      assert result["expires_in"] == 7200
    end
  end
end