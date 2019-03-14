defmodule Wechat.Adapter.Sandbox do
  @moduledoc """
  Sandbox adapter, save data in local process, don't use it in production.
  """

  use Agent

  @behaviour Wechat.Adapter

  def start_link(_), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @impl true
  def read_token(appid), do: Agent.get(__MODULE__, &Map.fetch(&1, appid))

  @impl true
  def write_token(appid, token), do: Agent.update(__MODULE__, &Map.put(&1, appid, token))
end
