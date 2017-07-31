defmodule Wechat.Utils.MsgParser do
  @moduledoc """
  Parse wechat xml message.
  Generate a map structured message with plain xml.
  """

  # attrs
  # [{<<"tousername">>,[],[<<"gh_7e071da28932">>]},
  # {<<"fromusername">>,[],[<<"oi00OuKAhA8bm5okpaIDs7WmUZr4">>]},
  # {<<"createtime">>,[],[<<"1468999644">>]},
  # {<<"msgtype">>,[],[<<"text">>]},
  # {<<"content">>,[],[<<229,147,136>>]},
  # {<<"msgid">>,[],[<<"6309305429231578443">>]}]

  # return
  # %{
  #   content => <<229,147,136>>,
  #   createtime => <<"1468999644">>,
  #   fromusername => <<"oi00OuKAhA8bm5okpaIDs7WmUZr4">>,
  #   msgid => <<"6309305429231578443">>,
  #   msgtype => <<"text">>,
  #   tousername => <<"gh_7e071da28932">>
  # }
  def parse(xml) do
    [{"xml", [], attrs}] = Floki.find(xml, "xml")
    for {key, _, [value]} <- attrs, into: %{} do
      {String.to_atom(key), value}
    end
  end
end
