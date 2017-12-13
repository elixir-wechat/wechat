defmodule Wechat.Workers.AccessToken do
  @moduledoc false

  use GenServer

  alias Wechat.Config
  alias Wechat.API

  @name __MODULE__
  @default_refresh_interval :timer.minutes(30)
  @default_fetcher {API, :access_token, []}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @name)
  end

  def init(_) do
    state = do_refresh()
    {:ok, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state["access_token"], state}
  end

  def handle_info(:refresh, _state) do
    state = do_refresh()
    {:noreply, state}
  end

  defp do_refresh do
    Process.send_after(self(), :refresh, refresh_interval())

    {mod, f, args} = env(:access_token_fetcher, @default_fetcher)
    apply(mod, f, args)
  end

  def refresh_interval do
    env(:access_token_refresh_interval, @default_refresh_interval)
  end

  defp env(key, default) do
    case Config.config[key] do
      nil -> default
      val -> val
    end
  end

  def get do
    GenServer.call(@name, :get)
  end
end
