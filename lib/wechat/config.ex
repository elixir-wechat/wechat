defmodule Wechat.Config do
  @moduledoc """
  Config for wechat API.
  """

  @default_adapter_opts {Wechat.Adapters.Sandbox, []}

  @doc """
  Get wechat config.
  """
  def config do
    Application.get_all_env(:wechat)
  end

  @doc """
  Get adapter config, default is `Wechat.Adapters.Sandbox`.
  """
  def adapter_opts do
    Application.get_env(:wechat, :adapter_opts, @default_adapter_opts)
  end

  @doc """
  Get adapter.
  """
  def adapter do
    elem(adapter_opts(), 0)
  end

  @doc """
  Get httpoison config.
  """
  def httpoison_opts do
    Application.get_env(:wechat, :httpoison_opts, [])
  end
end
