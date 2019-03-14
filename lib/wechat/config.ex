defmodule Wechat.Config do
  @moduledoc false

  def config do
    Application.get_all_env(:Wechat)
  end

  def adapter do
    config()[:adapter] || Wechat.Adapter.Sandbox
  end
end
