defmodule Router do
  @moduledoc """
  Router to accept push events.
  """
  use Plug.Router

  plug :match
  plug Wechat.Plugs.RequestValidator
  plug Wechat.Plugs.MessageParser
  plug :dispatch

  get "/wechat" do
    send_resp(conn, 200, conn.query_params["echostr"])
  end

  post "/wechat" do
    IO.inspect conn.body_params
    send_resp(conn, 200, "success")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  def start(port \\ 4000) do
    Plug.Adapters.Cowboy.http Router, [], port: port
  end

  def stop do
    Plug.Adapters.Cowboy.shutdown Router.HTTP
  end

  use Plug.ErrorHandler
  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
