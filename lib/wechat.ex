defmodule Wechat do
  @moduledoc """
  Use this module to build your own API wrapper for a client.

  ## Example

      def MyApp.Wechat do
        use Wechat, otp_app: :my_app

        def users do
          client() |> Wechat.User.get()
        end
      end
  """

  alias Wechat.Client

  @callback client() :: Client.t()

  @callback config() :: Keyword.t()

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Wechat

      otp_app = Keyword.fetch!(opts, :otp_app)

      @otp_app otp_app

      @impl true
      def config do
        Application.get_env(@otp_app, __MODULE__, [])
      end

      @impl true
      def client do
        Wechat.Client.new(config())
      end
    end
  end
end
