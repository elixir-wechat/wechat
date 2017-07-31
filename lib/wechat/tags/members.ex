defmodule Wechat.Tags.Members do
  @moduledoc false

  alias Wechat.API

  def get_blacklist(openid \\ "") do
    API.post "/tags/members/getblacklist", %{
      begin_openid: openid
    }
  end

  def batch_blacklist(openids) do
    API.post "/tags/members/batchblacklist", %{
      openid_list: openids
    }
  end

  def batch_unblacklist(openids) do
    API.post "/tags/members/batchunblacklist", %{
      openid_list: openids
    }
  end
end
