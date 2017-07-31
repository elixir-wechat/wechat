defmodule Wechat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Wechat.Workers.AccessToken, []},
      {Wechat.Workers.JSAPITicket, []}
    ]

    opts = [strategy: :one_for_one, name: Wechat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
