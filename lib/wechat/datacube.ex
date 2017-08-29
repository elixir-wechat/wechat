defmodule Wechat.Datacube do
  @moduledoc """
  Datacube API.

  ref: https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421141082
  """

  use Wechat.HTTP, host: "https://api.weixin.qq.com/datacube/"

  apis = ~W(
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

  for api <- apis do
    url = api |> to_string |> String.split("_") |> Enum.join
    def unquote(api)(begin_date, end_date) do
      post(unquote(url), %{
        begin_date: begin_date,
        end_date: end_date
      })
    end
  end
end
