defmodule Wechat.DatacubeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.Datacube

  test "all function was defined" do
    funcs = ~W(
      get_user_summary
      get_user_cumulate
      get_article_summary
      get_article_total
      get_user_read
      get_user_read_hour
      get_user_share
      get_user_share_hour
      get_upstream_msg
      get_upstream_msg_hour
      get_upstream_msg_week
      get_upstream_msg_month
      get_upstream_msg_dist
      get_upstream_msg_dist_week
      get_upstream_msg_dist_month
      get_interface_summary
      get_interface_summary_hour
    )a
    module_functions = Datacube.__info__(:functions)

    for f <- funcs do
      assert {f, 2} in module_functions
    end
  end

  test "#get_interface_summary" do
    use_cassette "datacube_get_interface_summary" do
      result = Datacube.get_interface_summary("2017-8-23", "2017-8-28")

      assert result["list"]
    end
  end
end
