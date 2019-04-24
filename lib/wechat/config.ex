defmodule Wechat.Config do
  @moduledoc false

  @default_adapter_opts {Wechat.Adapters.Sandbox, []}

  def config do
    Application.get_all_env(:wechat)
  end

  def adapter_opts do
    Application.get_env(:wechat, :adapter_opts, @default_adapter_opts)
  end

  def adapter do
    elem(adapter_opts(), 0)
  end

  def httpoison_opts do
    Application.get_env(:wechat, :httpoison_opts, [])
  end
end
