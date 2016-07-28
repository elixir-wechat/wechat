defmodule Wechat.Plugs.CheckMsgSignature do
  @moduledoc false

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    {:ok, body, conn} = read_body(conn)
    msg = parse_xml(body)
    assign(conn, :msg, msg)
  end


  @doc """
  # body
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
  """
  defp parse_xml(body) do
    [{"xml", [], attrs}] = Floki.find(body, "xml")
    List.foldl(attrs, %{}, fn({key, [], [value]}, acc)->
      Map.put_new(acc, String.to_atom(key), value)
    end)
  end
end
