defmodule Wechat.Utils.XMLParserTest do
  use ExUnit.Case, async: true

  import Wechat.Utils.XMLParser

  @xml """
  <xml>
  <ToUserName><![CDATA[gh_7e071da28932]]></ToUserName>
  <FromUserName><![CDATA[oi00OuKAhA8bm5okpaIDs7WmUZr4]]></FromUserName>
  <CreateTime>1555088738</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content><![CDATA[hello]]></Content>
  <MsgId>22263520920587027</MsgId>
  </xml>
  """

  test "parse xml" do
    xml = parse(@xml)
    assert xml[:ToUserName] == "gh_7e071da28932"
    assert xml[:FromUserName] == "oi00OuKAhA8bm5okpaIDs7WmUZr4"
    assert xml[:MsgType] == "text"
    assert xml[:Content] == "hello"
    assert xml[:MsgId] == "22263520920587027"
  end
end
