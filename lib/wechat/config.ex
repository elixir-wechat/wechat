defmodule Wechat.Config do
  @moduledoc false

  def config do
    Application.get_all_env(:wechat)
  end

  def adapter do
    config()[:adapter] || Wechat.Adapters.Sandbox

  def httpoison_opts do
    Application.get_env(:wechat, :httpoison_opts, [])
  end
end
