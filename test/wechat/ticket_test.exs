defmodule Wechat.TicketTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wechat.Ticket

  test "retrieve jsapi ticket" do
    use_cassette "ticket_jsapi" do
      result = Ticket.jsapi_ticket
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
      assert result["expires_in"] == 7200
      assert Map.has_key?(result, "ticket")
    end
  end

  test "retrieve api ticket" do
    use_cassette "ticket_wx_card" do
      result = Ticket.api_ticket
      assert result["errcode"] == 0
      assert result["errmsg"] == "ok"
      assert result["expires_in"] == 7200
      assert Map.has_key?(result, "ticket")
    end
  end
end